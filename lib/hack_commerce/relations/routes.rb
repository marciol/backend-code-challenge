require 'rom-sql'

class Routes < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      has_many :stretches
      has_many :distances, through: :stretches
    end
  end
end
