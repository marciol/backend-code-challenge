class Stretch < HackCommerce::Entity
  attribute :route_id,    Types::Int
  attribute :distance_id, Types::Int
  attribute :created_at,  Types::DateTime
  attribute :updated_at,  Types::DateTime
end
