require 'spec_helper'

describe DistanceRepository do
  let(:repository) { DistanceRepository.new }

  before do
    repository.clear
  end

  describe '#upsert' do
    it 'insert a new distance' do
      distance = repository.upsert(origin: 'A', destination: 'B', value: 100)
      distance.must_equal repository.find(distance.id)
    end

    it 'update an already inserted distance with same origin and destination' do
      distance = repository.create(origin: 'A', destination: 'B', value: 100)
      repository.upsert(origin: 'A', destination: 'B', value: 100).must_equal distance
    end
  end

end
