class AssociateRouteWithDistancesOperation
	attr_reader :route_repository, :distance_repository, :stretch_repository

	def initialize(stretch_repository: StretchRepository.new)
		@stretch_repository = stretch_repository
	end

	def call(route, destinations)
		transaction do
			associate_route_and_distances(route, distances)
			Route.new(route.to_h.merge(distances: distances))
		end
	end

	def transaction(&blk)
		stretch_repository.transaction(&blk)
	end

	def associate_route_and_distances(route, distances)
		distances.each do |distance|
			stretch_repository.create(route_id: route.id, distance_id: distance.id)
		end
	end
end