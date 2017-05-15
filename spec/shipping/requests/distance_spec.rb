require 'spec_helper'

describe 'Shipping distance' do
  describe '#create' do
    include Rack::Test::Methods

    let(:repository) { DistanceRepository.new }

    before do
      repository.clear
    end

    def app
      Hanami.app
    end

    it 'creates a new distance' do
      post '/shipping/distances', distance: {
        origin:      'A',
        destination: 'B',
        value: 100
      }

      last_response.must_be :ok?
      last_response.body.must_equal 'OK'
      repository.last.to_h.values_at(:origin, :destination, :value).must_equal ['A', 'B', 100]
    end

    describe 'with an already created distance' do
      before do
        @distance = repository.create(origin: 'A', destination: 'B', value: 100)
      end

      it 'only update the value' do
        post '/shipping/distances', distance: {
          origin:      'A',
          destination: 'B',
          value: 150
        }
        last_response.must_be :ok?
        last_response.body.must_equal 'OK'
        repository.all.size.must_equal 1
        repository.last.to_h.values_at(:origin, :destination, :value).must_equal ['A', 'B', 150]
      end
    end

  end
end