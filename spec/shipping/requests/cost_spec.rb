require 'spec_helper'

describe 'Shipping cost' do
  describe '#show' do
    include Rack::Test::Methods

    let(:distance_repository) { DistanceRepository.new }
    let(:distances_graph_repository) { DistancesGraphRepository.new }

    before do
      distance_repository.clear
      distance_repository.create(origin: 'A', destination: 'B', value: 7)
      distance_repository.create(origin: 'A', destination: 'C', value: 8)
      distance_repository.create(origin: 'B', destination: 'F', value: 2)
      distance_repository.create(origin: 'B', destination: 'A', value: 7)
      distance_repository.create(origin: 'C', destination: 'A', value: 8)
      distance_repository.create(origin: 'C', destination: 'F', value: 6)
      distance_repository.create(origin: 'C', destination: 'G', value: 4)
      distance_repository.create(origin: 'D', destination: 'F', value: 8)
      distance_repository.create(origin: 'E', destination: 'H', value: 1)
      distance_repository.create(origin: 'F', destination: 'D', value: 8)
      distance_repository.create(origin: 'F', destination: 'G', value: 9)
      distance_repository.create(origin: 'F', destination: 'C', value: 6)
      distance_repository.create(origin: 'F', destination: 'H', value: 3)
      distance_repository.create(origin: 'F', destination: 'B', value: 2)
      distance_repository.create(origin: 'G', destination: 'C', value: 4)
      distance_repository.create(origin: 'G', destination: 'F', value: 9)
      distance_repository.create(origin: 'H', destination: 'E', value: 1)
      distance_repository.create(origin: 'H', destination: 'F', value: 3)
      distances_graph_repository.refresh_graph
    end

    def app
      Hanami.app
    end

    it 'gets a cost of shipping A to H' do
      get '/shipping/cost', origin: 'A', destination: 'H', weight: 100
      last_response.must_be :ok?
      last_response.body.must_equal '180.0'
    end
  end
end
