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

  describe '#load_vertexes' do
    before do
      repository.create(origin: 'A', destination: 'B', value: 100)
      repository.create(origin: 'A', destination: 'C', value: 100)
      repository.create(origin: 'B', destination: 'A', value: 100)
      repository.create(origin: 'B', destination: 'C', value: 100)
    end

    it 'returns all vertexes from database' do
      repository.load_vertexes.must_equal({'A' => {'B' => 100, 'C' => 100}, 'B' => {'A' => 100, 'C' => 100}, 'C' => {'A' => 100, 'B' => 100}})
    end
  end

  describe '#by_origin' do
    before do
      @fst = repository.create(origin: 'A', destination: 'B', value: 100)
      @snd = repository.create(origin: 'B', destination: 'C', value: 100)
      @trd = repository.create(origin: 'C', destination: 'B', value: 100)
    end

    it 'returns distances by origin name' do
      repository.by_origin('A', 'B').to_a.must_equal [@fst, @snd]
    end
  end

  describe '#find_by_origin' do
    before do
      @distance = repository.create(origin: 'A', destination: 'B', value: 100)
    end

    it 'returns distance by origin name' do
      repository.find_by_origin('A').must_equal @distance
    end
  end

  describe '#find_by_origin_and_destination' do
    before do
      @fst = repository.create(origin: 'A', destination: 'B', value: 100)
      repository.create(origin: 'B', destination: 'C', value: 100)
    end

    it 'returns distance by origin name' do
      repository.find_by_origin_and_destination('A', 'B').must_equal @fst
    end
  end
end
