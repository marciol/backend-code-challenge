class DijkstrasGraph
	INFINITY = (2**(0.size * 8 -2) -1)

	attr_reader :vertices

	def initialize
		@vertices = {}
	end

	def add_vertex(name, edges = {})
		@vertices[name] = edges
	end

	def shortest_path(start, finish)
		distances = {} # Distance from start to node
		previous = {} # Previous node in optimal path from source
		nodes = Containers::MinHeap.new # kanwei li's min heap of all nodes in Graph
			
		@vertices.each do |vertex, value|
			if vertex == start # Set root node as distance of 0
				distances[vertex] = 0
				nodes.push(0, vertex)
			else
				distances[vertex] = INFINITY 
				nodes.push(INFINITY, vertex)
			end
			previous[vertex] = nil
		end
			
		while nodes
			current = nodes.min! # Vertex in nodes with current distance in distances

			if current == finish # If the closest node is our target we're done so print the path
				path = []
				while previous[current] # Traverse through nodes til we reach the root which is 0
					path.push(current)
					current = previous[current]
				end
				break
			end
				
			if current == nil # All remaining vertices are inaccessible from source
				break            
			end
				
			@vertices[current].each do | neighbor, value | # Look at all the nodes that this vertex is attached to
				alt = distances[current] + @vertices[current][neighbor] # Alternative path distance
				if alt < distances[neighbor] # If there is a new shortest path update our priority queue (relax)
					distances[neighbor] = alt
					previous[neighbor] = current 
					change_priority(nodes, neighbor, alt)
				end
			end
		end
		path = path + [start] unless path.empty?
		return [path.reverse, distances]
	end
	
	def to_s
		return @vertices.inspect
	end

	private

	def change_priority(nodes, key, value)
		nodes.delete(key)
		nodes.push(value, key)
	end
end