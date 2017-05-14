require 'spec_helper'

describe Distance do

  let(:repository) { DistanceRepository.new }

  before do
    repository.clear
  end

  it 'all attributes are present on instantiated entity' do
    distance = Distance.new(origin: 'A', destination: 'B', value: 100)
    distance.origin.must_equal 'A'
    distance.destination.must_equal 'B'
    distance.value.must_equal 100
  end

  describe '#shortest_path' do
		before do
			repository.create(origin: 'A', destination: 'B', value: 7)
			repository.create(origin: 'A', destination: 'C', value: 8)
			repository.create(origin: 'B', destination: 'F', value: 2)
			repository.create(origin: 'B', destination: 'A', value: 7)
			repository.create(origin: 'C', destination: 'A', value: 8)
			repository.create(origin: 'C', destination: 'F', value: 6)
			repository.create(origin: 'C', destination: 'G', value: 4)
			repository.create(origin: 'D', destination: 'F', value: 8)
			repository.create(origin: 'E', destination: 'H', value: 1)
			repository.create(origin: 'F', destination: 'D', value: 8)
			repository.create(origin: 'F', destination: 'G', value: 9)
			repository.create(origin: 'F', destination: 'C', value: 6)
			repository.create(origin: 'F', destination: 'H', value: 3)
			repository.create(origin: 'F', destination: 'B', value: 2)
			repository.create(origin: 'G', destination: 'C', value: 4)
			repository.create(origin: 'G', destination: 'F', value: 9)
			repository.create(origin: 'H', destination: 'E', value: 1)
			repository.create(origin: 'H', destination: 'F', value: 3)
		end

		it 'returns the shortest path distances from one distance to another distance' do
			origin = repository.find_by_origin('A')
			destination = repository.find_by_origin('H')
			origin.shortest_path(destination).must_equal repository.by_origin('B', 'F', 'H').to_a
		end

		describe 'when distances are not connected' do
			before do
				repository.create(origin: 'I', destination: 'Z', value: 3)
			end

			it 'returns empty array as result' do
				origin = repository.find_by_origin('A')
				destination = repository.find_by_origin('I')
				origin.shortest_path(destination).must_be_empty
	    end
		end
  end
end
