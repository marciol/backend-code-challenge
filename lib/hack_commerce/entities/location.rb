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

		origin_names, _ = graph.shortest_path(self.name, location.name)

		@repository.by_origin(*origin_names).to_a
	end
end