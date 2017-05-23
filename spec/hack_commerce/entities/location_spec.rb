require 'spec_helper'

describe Location do

  let(:distance_repository) { DistanceRepository.new }
  let(:distances_graph_repository) { DistancesGraphRepository.new }

  before do
    distance_repository.clear
  end

  describe '#shortest_path' do
    before do
      distance_repository.create(origin: 'A', destination: 'C', value: 8)
      distance_repository.create(origin: 'B', destination: 'A', value: 7)
      distance_repository.create(origin: 'C', destination: 'A', value: 8)
      distance_repository.create(origin: 'C', destination: 'F', value: 6)
      distance_repository.create(origin: 'C', destination: 'G', value: 4)
      distance_repository.create(origin: 'D', destination: 'F', value: 8)
      distance_repository.create(origin: 'E', destination: 'H', value: 1)
      distance_repository.create(origin: 'F', destination: 'D', value: 8)
      distance_repository.create(origin: 'F', destination: 'G', value: 9)
      distance_repository.create(origin: 'F', destination: 'C', value: 6)
      distance_repository.create(origin: 'F', destination: 'B', value: 2)
      distance_repository.create(origin: 'G', destination: 'C', value: 4)
      distance_repository.create(origin: 'G', destination: 'F', value: 9)
      distance_repository.create(origin: 'H', destination: 'E', value: 1)
      distance_repository.create(origin: 'H', destination: 'F', value: 3)

      @fst = distance_repository.create(origin: 'A', destination: 'B', value: 7)
      @snd = distance_repository.create(origin: 'B', destination: 'F', value: 2)
      @trd = distance_repository.create(origin: 'F', destination: 'H', value: 3)
      distances_graph_repository.refresh_graph
    end

    it 'returns the shortest path distances from one distance to another distance' do
      origin = Location.new(name: 'A')
      destination = Location.new(name: 'H')
      origin.shortest_path(destination).must_equal [@fst, @snd, @trd]
    end

    describe 'when distances are not connected' do
      before do
        distance_repository.create(origin: 'I', destination: 'Z', value: 3)
        distances_graph_repository.refresh_graph
      end

      it 'returns empty array as result' do
        origin = Location.new(name: 'A')
        destination = Location.new(name: 'I')
        origin.shortest_path(destination).must_be_empty
      end
    end
  end
end
