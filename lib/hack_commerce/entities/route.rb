class Route < HackCommerce::Entity
  attribute :id,           Types::Int.meta(primary_key: true)
  attribute :origin,       Types::String
  attribute :destination,  Types::String
end
