require 'rom-sql'

class Stretches < ROM::Relation[:sql]
  schema(infer: true) do
    attribute :id, Types::Int
    primary_key :id

    associations do
      belongs_to :route
      belongs_to :distance
    end
  end
end
