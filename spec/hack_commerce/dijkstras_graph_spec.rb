require 'spec_helper'

describe DijkstrasGraph do

	let(:graph) { DijkstrasGraph.new }

	describe '#add_vertex' do
		it 'adds vertices to graph' do
			graph.add_vertex('A', {'B' => 7, 'C' => 8})
			graph.vertices.must_equal({'A' => {'B' => 7, 'C' => 8}})
		end
	end


	describe '#shortest_path' do
		before do
      graph.add_vertex('A', {'B' => 7, 'C' => 8})
      graph.add_vertex('B', {'A' => 7, 'F' => 2})
      graph.add_vertex('C', {'A' => 8, 'F' => 6, 'G' => 4})
      graph.add_vertex('D', {'F' => 8})
      graph.add_vertex('E', {'H' => 1})
      graph.add_vertex('F', {'B' => 2, 'C' => 6, 'D' => 8, 'G' => 9, 'H' => 3})
      graph.add_vertex('G', {'C' => 4, 'F' => 9})
      graph.add_vertex('H', {'E' => 1, 'F' => 3})
      graph.add_vertex('I')
		end

		it 'returns the shortest path and distances for each node' do
			graph.shortest_path('A', 'H').must_equal([['A', 'B', 'F', 'H'], {'A' => 0, 'B' => 7, 'C' => 8, 'D' => 17, 'E' => DijkstrasGraph::INFINITY, 'F' => 9, 'G' => 12, 'H' => 12, 'I' => DijkstrasGraph::INFINITY}])
		end

		it 'returns and empty path and all attempted distances for a no connected node' do
			graph.shortest_path('H', 'I').must_equal([[], {'A' => 12, 'B' => 5, 'C' => 9, 'D' => 11, 'E' => 1, 'F' => 3, 'G' => 12, 'H' => 0, 'I' => DijkstrasGraph::INFINITY}])
    end
	end
end
