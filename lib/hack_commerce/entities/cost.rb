class Cost
	SHIPPING_TAX = BigDecimal.new("0.15")

	def initialize(distances:, weight:)
		raise ArgumentError.new 'is not possible to calculate without a route' if distances.empty?
		@distances = distances
		@weight = weight
	end

	def calculate(shipping_tax: SHIPPING_TAX)
		raise ArgumentError.new 'shipping_tax must be BigDecimal' unless shipping_tax.is_a? BigDecimal
		@distances.map(&:value).reduce(:+) * @weight * shipping_tax
	end
end