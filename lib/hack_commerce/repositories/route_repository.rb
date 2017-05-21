class RouteRepository < HackCommerce::Repository[:routes]
	relations :distances
  entity Route

	def find_by_origin_and_destination(origin:, destination:)
		routes.as(:entity).where(origin: origin, destination: destination).one
	end

	def associate_route_with_distances(route, distances)
		transaction do
			stretches_data = 
				distances.map { |d| {distance_id: d.to_h[:id], route_id: route.to_h[:id]} }

			stretches_assoc = assoc(:stretches, route)

			stretches_assoc.delete

			stretches_data.each { |s| stretches_assoc.add(s) }

			distances = self.distances.read <<~SQL
				SELECT 
					d.* 
				FROM distances d 
				INNER JOIN stretches s ON d.id = s.distance_id
				INNER JOIN routes r ON r.id = s.route_id
				WHERE r.id = #{route.id}
			SQL
		end
		Route.new(route.to_h.merge(distances: distances))
	end

	def create_with_distances(attrs)
		origin, destination, distances_attrs = attrs.values_at(:origin, :destination, :distances)
		transaction do
			route = create(origin: origin, destination: destination)

			saved_dists, to_save_dists = 
				distances_attrs.map do |d| 
					distances.where(origin: d[:origin], destination: d[:destination]).
										first || Distance.new(d)
				end.partition(&:id)

			dists = saved_dists + to_save_dists.map { |d| distances.create(d) }

			dists.each do |d|
				stretches.create(route_id: route.id, distance_id: d.id)
			end

			route
		end
	end
end
