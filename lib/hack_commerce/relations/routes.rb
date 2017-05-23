require 'rom-sql'

class Routes < ROM::Relation[:sql]
  schema(infer: true) do
    attribute :id, Types::Int
    primary_key :id

    associations do
      has_many :stretches
      has_many :distances, through: :stretches
    end
  end
end
