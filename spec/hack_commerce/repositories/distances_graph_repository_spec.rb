require 'spec_helper'

describe DistancesGraphRepository do
	let(:distances_repository) { DistanceRepository.new }
	let(:repository) { DistancesGraphRepository.new }

	before do
		distances_repository.clear
    distances_repository.create(origin: 'A', destination: 'B', value: 100)
    distances_repository.create(origin: 'A', destination: 'C', value: 100)
    distances_repository.create(origin: 'B', destination: 'A', value: 100)
    distances_repository.create(origin: 'B', destination: 'C', value: 100)
    repository.refresh_graph
	end

	describe '#graph' do
		it 'returns the global distances graph from database' do
			repository.graph.vertexes.must_equal({'A' => {'B' => 100, 'C' => 100}, 'B' => {'A' => 100, 'C' => 100}, 'C' => {'A' => 100, 'B' => 100}}) 
		end
	end

	describe '#refresh_graph' do
		before do
	    distances_repository.upsert(origin: 'A', destination: 'C', value: 50)
	    distances_repository.upsert(origin: 'B', destination: 'C', value: 50)
	    repository.refresh_graph
		end

		it 'refreshes underlying materialized view changing returning values' do
			repository.graph.vertexes.must_equal({'A' => {'B' => 100, 'C' => 50}, 'B' => {'A' => 100, 'C' => 50}, 'C' => {'A' => 50, 'B' => 50}}) 
		end
	end
end
