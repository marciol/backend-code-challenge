require 'spec_helper'

describe Cost do

  let(:distances) { 
  	[Distance.new(origin: 'A', destination: 'B', value: 3),
  	 Distance.new(origin: 'B', destination: 'C', value: 3),
  	 Distance.new(origin: 'C', destination: 'D', value: 3)] 
  }

  let(:cost) { Cost.new(distances: distances, weight: 100) }

  describe '.new' do
		it 'raises an ArgumentError exception when distances is empty' do
			err = proc {
				Cost.new(distances: [], weight: 100)
			}.must_raise ArgumentError
			err.message.must_equal 'is not possible to calculate without a route'
		end
  end

	describe '#calculate' do
		it 'calculates the cost based on distances and weight with a default shipping tax' do
			cost.calculate.must_equal BigDecimal.new("135.0")
		end

		it 'calculates the cost based on distances and weight for a specified shipping tax' do
			cost.calculate(shipping_tax: BigDecimal.new("0.30")).must_equal BigDecimal.new("270.0")
		end

		it 'raises an ArgumentError exception when shipping tax is not BigDecimal' do
			err = proc {
				cost.calculate(shipping_tax: 0.30)
			}.must_raise ArgumentError
			err.message.must_equal 'shipping_tax must be BigDecimal'
		end
	end
end
