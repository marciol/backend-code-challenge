class RecalculateDistancesWorker
	include Sidekiq::Worker
  attr_reader :stretch_repository, :distances_graph_repository

	def perform(route_ids,
              distances_graph_repository = DistancesGraphRepository.new,
              stretch_repository = StretchRepository.new, 
              route_repository = RouteRepository.new)

    setup(stretch_repository, distances_graph_repository)

    refresh_graph

    route_ids.each do |route_id|
      route = route_repository.find(route_id)
      clear_associated_stretches(route)
      distances = recalculate_distances(route)
      associate_route_to_distances(route, distances)
    end
	end

  def setup(stretch_repository, distances_graph_repository)
    @stretch_repository = stretch_repository
    @distances_graph_repository = distances_graph_repository
  end

  def refresh_graph
		distances_graph_repository.refresh_graph
  end

  def clear_associated_stretches(route)
    stretch_repository.stretches.where(route_id: route.id).delete
  end

  def recalculate_distances(route)
    origin = Location.new(name: route.origin)
    destination = Location.new(name: route.destination)
    origin.shortest_path(destination)
  end

  def associate_route_to_distances(route, distances)
    distances.map(&:id).product([route.id]).each do |distance_id, route_id|
      stretch_repository.create(distance_id: distance_id, route_id: route_id)
    end
  end
end
