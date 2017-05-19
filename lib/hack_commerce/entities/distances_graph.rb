class DistancesGraph < HackCommerce::Entity
  attribute :vertexes,   Types::Json
  attribute :updated_at, Types::DateTime

	# hack to avoid transforming all keys on symbols
	# there are discussions about how to deal with it
	# on this issues
	# https://github.com/hanami/model/pull/395
	# https://github.com/hanami/model/issues/394
	#class Schema < Hanami::Entity::Schema
	#	def call(attributes)
	#    Hanami::Utils::Hash.new(
	#      schema.call(attributes)
	#    )
	#	end
	#	alias [] call
	#end

	#def self.schema 
	#  Schema.new
	#end
end
