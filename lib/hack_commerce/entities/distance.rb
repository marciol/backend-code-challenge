class Distance < HackCommerce::Entity
  attribute :id,          Types::Int.default(1)
  attribute :origin,      Types::String
  attribute :destination, Types::String
  attribute :value,       Types::Decimal
end
