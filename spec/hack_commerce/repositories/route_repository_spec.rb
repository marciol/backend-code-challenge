require 'spec_helper'

describe RouteRepository do
	let(:repository) { RouteRepository.new }
	before do
		repository.clear
	end

	describe '#find_by_origin_and_destination' do
		before do
			@expected_route = repository.create(origin: 'A', destination: 'B')
			repository.create(origin: 'A', destination: 'C')
		end

		it 'returns only the route that matches origin and destination' do
			route = repository.find_by_origin_and_destination(origin: 'A', destination: 'B')
			route.must_equal @expected_route
		end
	end
end
