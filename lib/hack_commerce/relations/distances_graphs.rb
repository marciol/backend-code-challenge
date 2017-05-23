require 'rom-sql'

class DistancesGraphs < ROM::Relation[:sql]
  schema(:distances_graph, infer: true)
end
