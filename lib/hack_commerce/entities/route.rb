class Route
#	attributes do
#		attribute :id,           Types::Int
#		attribute :origin,       Types::String
#		attribute :destination,  Types::String
#		attribute :distances,    Types::Collection(Distance)
#		attribute :created_at,   Types::Time
#		attribute :updated_at,   Types::Time
#	end
#
#	def to_h
#		super.each_with_object({}) do |(k, v), result|
#      v = v.to_h if v.respond_to?(:to_hash)
#      v = v.map(&:to_h) if v.is_a?(Array)
#      result[k] = v
#    end
#	end
end