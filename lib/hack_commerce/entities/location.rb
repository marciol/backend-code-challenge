class Location
	attr_reader :name

	def initialize(repository: DistanceRepository.new, name:)
		@repository = repository
		@name = name
	end

	def shortest_path(location, graph = DijkstrasGraph.new)
		@repository.load_vertexes.each do |node, distances|
			graph.add_vertex(node, distances)
		end

		path, _ = graph.shortest_path(self.name, location.name)

		path.each_cons(2).map do |origin, destination|
			@repository.find_by_origin_and_destination(origin, destination)
		end
	end
end