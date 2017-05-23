class Distances < ROM::Relation[:sql]
  schema(infer: true) do
    attribute :id, Types::Int
    primary_key :id

    associations do
      has_many :stretches
      has_many :routes, through: :stretches
    end
  end
end
