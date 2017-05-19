require 'rom-sql'

class Stretches < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      belongs_to :route
      belongs_to :distance
    end
  end
end
