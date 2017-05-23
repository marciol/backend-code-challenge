require 'spec_helper'

describe RecalculateDistancesWorker do
	describe '#perform' do

		let(:distances_graph_repository) { DistancesGraphRepository.new }
    let(:stretch_repository) { StretchRepository.new }
    let(:distance_repository) { DistanceRepository.new }
    let(:route_repository) { RouteRepository.new }
    let(:distances) do
      [{ origin: 'A', destination: 'B', value: 100 },
       { origin: 'B', destination: 'C', value: 100 }].map do |attrs|
         distance_repository.create(attrs)
       end
    end
    let(:route_entity) do 
      route_repository.create(origin: 'A', destination: 'C') 
    end
		let(:worker) { RecalculateDistancesWorker.new }

    before do
      distance_repository.clear
      route_repository.clear
      stretch_repository.clear
      @stretches = distances.map(&:id).product([route_entity.id]).map do |distance_id, route_id|
        stretch_repository.create(distance_id: distance_id, route_id: route_id)
      end
    end

		it 'changes the related associations' do
      worker.perform([route_entity.id])
      stretch_repository.all.wont_equal @stretches
		end
	end
end
