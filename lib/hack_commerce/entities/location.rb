class Location
  attr_reader :name

  def initialize(distance_repository: DistanceRepository.new, 
                 distances_graph_repository: DistancesGraphRepository.new,
                 name:)
    @distance_repository = distance_repository
    @distances_graph_repository = distances_graph_repository
    @name = name
  end

  def shortest_path(location, graph = DijkstrasGraph.new)
    @distances_graph_repository.graph.vertexes.each do |node, distances|
      graph.add_vertex(node, distances)
    end

    path, _ = graph.shortest_path(self.name, location.name)

    path.each_cons(2).map do |origin, destination|
      @distance_repository.find_by_origin_and_destination(origin, destination)
    end
  end
end
