require 'spec_helper'
require_relative '../../../../apps/shipping/controllers/distances/create'

describe Shipping::Controllers::Distances::Create do
  let(:action)     { Shipping::Controllers::Distances::Create.new(repository: repository, worker: worker) }
  let(:distance)   { Distance.new(origin: 'A', destination: 'B', value: 100) }
  let(:repository) { DistanceRepository.new }
  let(:worker) { RefreshDistancesGraphWorker }

  describe 'with invalid params' do

    describe 'when distance value out of limit' do
      [-1, 1000_001].each do |value|
        let(:params) { Hash[distance: {origin: 'A', destination: 'B', value: value}] }

        describe "for value #{value}" do
          it 'returns http status error with error message' do
            response = action.call(params)

            response[0].must_equal 422
            response[2].must_equal ['Value must be one of: 0 - 100000']
          end
        end
      end
    end

    describe 'when either origin, destination or value are not present' do
      arg_state = ->(value) { value.to_s.empty? ? 'empty' : value }

      [['' , '' ],
       ['A', '' ],
       ['' , 'B']].each do |o, d|

        let(:params) { Hash[distance: {origin: o, destination: d, value: 100}] }

        describe "for origin: #{arg_state.(o)}, destination: #{arg_state.(d)}" do
          it 'returns http status error' do
            response = action.call(params)
            response[0].must_equal 422
          end
        end
      end
    end
  end

  describe 'with valid params' do
    let(:params) { Hash[distance: {origin: 'A', destination: 'B', value: 100} ] }
    let(:worker) do 
      Class.new do
        class << self
          attr_accessor :has_been_called
          def perform_async(*args)
            @has_been_called = true
          end
        end
      end
    end

    it 'returns status 200 and OK message' do
      repository.stub :upsert, distance do
        response = action.call(params)
        response[0].must_equal 200
        response[2].must_equal ['OK']
      end
    end

    it 'calls the RefreshDistancesGraphWorker' do
      action.call(params)
      worker.has_been_called.must_equal true
    end
  end
end
