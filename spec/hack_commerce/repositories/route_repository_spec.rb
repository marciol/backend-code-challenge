require 'spec_helper'

describe RouteRepository do

	let(:repository) { RouteRepository.new }
  let(:distance_repository) { DistanceRepository.new }
  let(:stretch_repository) { StretchRepository.new }
  let(:stretches_relation) { HackCommerce.rom_container.relation(:stretches) }

	before do
		repository.clear
    distance_repository.clear
	end

	describe '#find_by_origin_and_destination' do
		before do
      repo = repository
      @expected_route = repo.create(origin: 'A', destination: 'B')
      repository.create(origin: 'A', destination: 'C')
		end

		it 'returns only the route that matches origin and destination' do
			route = repository.find_by_origin_and_destination(origin: 'A', destination: 'B')
			route.must_equal @expected_route
		end
	end

	describe '#find_by_origin_and_destination_with_distances' do
		before do
      route = repository.create(origin: 'A', destination: 'C')

      distances = [
        { origin: 'A', destination: 'B', value: 100 },
        { origin: 'B', destination: 'C', value: 100 },
      ].map { |attrs| distance_repository.create(attrs) }

      distances.map(&:id).product([route.id]).each do |distance_id, route_id|
        stretch_repository.create(distance_id: distance_id, route_id: route_id)
      end
		end

		it 'returns only the route that matches origin and destination' do
			route = repository.find_by_origin_and_destination_with_distances(origin: 'A', destination: 'C')
			route.origin.must_equal 'A'
      route.destination.must_equal 'C'
      route.distances.size.must_equal 2
      route.distances[0].origin.must_equal 'A'
      route.distances[0].destination.must_equal 'B'
		end
	end

	describe '#find_by_id_with_distances' do
    let(:route_entity) { repository.create(origin: 'A', destination: 'C') }

		before do
      distances = [
        { origin: 'A', destination: 'B', value: 100 },
        { origin: 'B', destination: 'C', value: 100 },
      ].map { |attrs| distance_repository.create(attrs) }

      distances.map(&:id).product([route_entity.id]).each do |distance_id, route_id|
        stretch_repository.create(distance_id: distance_id, route_id: route_id)
      end
		end

		it 'returns only the route that matches origin and destination' do
			route = repository.find_by_id_with_distances(route_entity.id)
			route.origin.must_equal 'A'
      route.destination.must_equal 'C'
      route.distances.size.must_equal 2
      route.distances[0].origin.must_equal 'A'
      route.distances[0].destination.must_equal 'B'
		end
	end

  describe '#create_and_associate_distances' do
    before do
      @dist1 = distance_repository.create(origin: 'A', destination: 'B', value: 100.0)
      @dist2 = distance_repository.create(origin: 'B', destination: 'C', value: 100.0)
    end

    it 'update route associating distances as structs' do
      route = repository.create_and_associate_distances(origin: 'B', destination: 'C', distances: [ @dist1, @dist2 ])
      stretches_relation.where(route_id: route.id, distance_id: @dist1.id).first.wont_be_nil 
      stretches_relation.where(route_id: route.id, distance_id: @dist2.id).first.wont_be_nil 
    end

    it 'update route associating distances as hashes' do
      route = repository.create_and_associate_distances(origin: 'B', destination: 'C', distances: [ @dist1.to_h, @dist2.to_h ])
      stretches_relation.where(route_id: route.id, distance_id: @dist1.id).first.wont_be_nil 
      stretches_relation.where(route_id: route.id, distance_id: @dist2.id).first.wont_be_nil 
    end
  end
end
