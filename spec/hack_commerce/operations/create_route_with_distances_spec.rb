require 'spec_helper'

describe AssociateRouteWithDistancesOperation do
	let(:route_repository) { RouteRepository.new }
	let(:distance_repository) { DistanceRepository.new }
	let(:stretch_repository) { StretchRepository.new }
	let(:route) { route_repository.create(origin: 'A', destination: 'B') }

	let(:distances) do
		['A', 'B', 100,
		 'A', 'C', 100, 
		 'B', 'C', 100].map do |origin, destination, value|
		 		distance_repository.create(
		 			origin: origin,
		 			destination: destination,
		 			value: value)
		 end
	end

	let(:operation) do 
		AssociateRouteWithDistancesOperation.new(
			route_repository: route_repository, 
			distance_repository: distance_repository,
			stretch_repository: stretch_repository)
	end

	before do
		route_repository.clear
		distance_repository.clear
		stretch_repository.clear
	end

	describe '#call' do
		it 'associates the route and distances' do
			expected_data = {
				origin: 'A', 
			  destination: 'B', 
			  distances: [{
			  	origin: 'A',
			  	destination: 'B',
			  	value: 100
			  }, {
			  	origin: 'A',
			  	destination: 'C',
			  	value: 50
			  }]
			}
			route = operation.call(route, distances)
			route_data = route.each_with_object({}) do |(k, v), o|
				next o if k == :id
			end
		end
	end
end
