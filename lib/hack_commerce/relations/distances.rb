class Distances < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      has_many :stretches
      has_many :routes, through: :stretches
    end
  end
end
