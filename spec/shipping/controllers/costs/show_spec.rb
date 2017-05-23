require 'spec_helper'
require_relative '../../../../apps/shipping/controllers/costs/show'
require 'minitest/stub_any_instance'

describe Shipping::Controllers::Costs::Show do
  let(:action) { Shipping::Controllers::Costs::Show.new }
  let(:params) { Hash[] }
  let(:distance_repository) { DistanceRepository.new }
  let(:route_repository) { RouteRepository.new }
  let(:stretch_repository) { StretchRepository.new }

  before do
    distance_repository.clear
    route_repository.clear
    stretch_repository.clear
  end

  describe 'with invalid params' do
    describe 'on the absense of any required parameter' do
      arg_state = ->(value) { value.to_s.empty? ? 'empty' : value }

      [['',  '',  ''   ],
       ['',  '',  100.0],
       ['',  'B', ''   ],
       ['',  'B', 100.0],
       ['A', '',  ''   ],
       ['A', '',  100.0],
       ['A', 'B', ''   ]].each do |o, d, w|

        let(:params) { Hash[{origin: o, destination: d, weight: w}] }

        describe "for origin: #{arg_state.(o)}, destination: #{arg_state.(d)}, weight: #{arg_state.(w)}" do
          it 'returns http status error' do
            response = action.call(params)
            response[0].must_equal 422
          end
        end
      end
    end
  end

  describe 'with valid params' do
    let(:params) { Hash[origin: 'A', destination: 'C', weight: 100.0] }
    let(:distances) {
      [{ origin: 'A', destination: 'B', value: 3, updated_at: Time.now },
       { origin: 'B', destination: 'C', value: 3, updated_at: Time.now },
       { origin: 'C', destination: 'D', value: 3, updated_at: Time.now }].map do |attrs|
         distance_repository.create(attrs)
       end
    }

    it 'returns status 200 with cost value' do
      Location.stub_any_instance :shortest_path, distances do
        response = action.call(params)
        response[0].must_equal 200
        response[2].must_equal ['135.0']
      end
    end

    it 'returns status 400 when path are not found' do
      Location.stub_any_instance :shortest_path, [] do
        response = action.call(params)
        response[0].must_equal 422
        response[2].must_equal ['is not possible to calculate without a route']
      end
    end

    describe 'when request cost twice' do
      before do
        Location.stub_any_instance :shortest_path, distances do
          response = action.call(params.merge('HTTP_IF_NONE_MATCH' => 'whatever'))
          @etag = response[1]['ETag']
        end
      end

      it 'returns 304 when distances not changed in elapsed time' do
        Location.stub_any_instance :shortest_path, distances do
          response = action.call(params.merge('HTTP_IF_NONE_MATCH' => @etag))
          response[0].must_equal 304
        end
      end

      it 'returns 304 when distances changed in elapsed time' do
        dist = distances[0]
        distances[0] = distance_repository.changeset(distances[0].id, updated_at: dist.updated_at + (60 * 10)).commit

        Location.stub_any_instance :shortest_path, distances do
          response = action.call(params.merge('HTTP_IF_NONE_MATCH' => @etag))
          response[0].must_equal 200
        end
      end
    end
  end
end
