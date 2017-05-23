class RouteRepository < HackCommerce::Repository[:routes]
	relations :distances, :stretches
  entity Route

	def find_by_origin_and_destination(origin:, destination:)
		routes.as(:entity).where(origin: origin, destination: destination).one
	end

  def find_by_origin_and_destination_with_distances(origin:, destination:)
    routes.where(origin: origin, destination: destination).combine(:distances).one
  end

  def find_by_id_with_distances(route_id)
    routes.by_pk(route_id).combine(:distances).one
  end

  def create_and_associate_distances(attrs)
    cmd = command(:routes)[:create_and_associate_distances] >> mappers[routes.to_ast]
    cmd.call(attrs)
  end
end
