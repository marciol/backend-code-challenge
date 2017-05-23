require 'spec_helper'

describe 'Shipping distance' do
  describe '#create' do
    include Rack::Test::Methods

    let(:distance_repository) { DistanceRepository.new }
    let(:route_repository) { RouteRepository.new }
    let(:distances_graph_repository) { DistancesGraphRepository.new }
    let(:stretch_repository) { StretchRepository.new }

    before do
      distance_repository.clear
      route_repository.clear
      stretch_repository.clear

      distances_graph_repository.refresh_graph
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
      distance_repository.last.to_h.values_at(:origin, :destination, :value).must_equal ['A', 'B', 100]
    end

    describe 'with an already created distance' do
      before do
        distance_repository.create(origin: 'A', destination: 'B', value: 100)
      end

      it 'only update the value' do
        post '/shipping/distances', distance: {
          origin:      'A',
          destination: 'B',
          value: 150
        }
        last_response.must_be :ok?
        last_response.body.must_equal 'OK'
        distance_repository.all.size.must_equal 1
        distance_repository.last.to_h.values_at(:origin, :destination, :value).must_equal ['A', 'B', 150]
      end

      it 'changes the distance graph' do
        Sidekiq::Testing.inline! do
          post '/shipping/distances', distance: {
            origin:      'A',
            destination: 'B',
            value: 150
          }
          distances_graph = distances_graph_repository.graph
          distances_graph.vertexes.must_equal({'A' => {'B' => 150}, 'B' => {'A' => 150}})
        end
      end
    end

    describe 'when there is an associated route' do
      before do
        route = route_repository.create(origin: 'A', destination: 'C')

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

        fst_distance = 
          distance_repository.create(origin: 'A', destination: 'B', value: 7)
        snd_distance = 
          distance_repository.create(origin: 'B', destination: 'F', value: 2)
        trd_distance = 
          distance_repository.create(origin: 'F', destination: 'H', value: 3)

        distances = [fst_distance, snd_distance, trd_distance]

        @stretches = distances.map(&:id).product([route.id]).map do |distance_id, route_id|
          stretch_repository.create(distance_id: distance_id, route_id: route_id)
        end
      end

      it 'recalculates route distances' do
        Sidekiq::Testing.inline! do
          post '/shipping/distances', distance: {
            origin:      'A',
            destination: 'B',
            value: 150
          }
          stretch_repository.all.wont_equal @stretches
        end
      end
    end
  end
end
