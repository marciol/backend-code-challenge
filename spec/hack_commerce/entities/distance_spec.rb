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
end
