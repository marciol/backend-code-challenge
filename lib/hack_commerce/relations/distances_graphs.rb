require 'rom-sql'

class DistancesGraphs < ROM::Relation[:sql]
  schema(infer: true)
end
