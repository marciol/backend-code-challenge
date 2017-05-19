class Distance < HackCommerce::Entity
  attribute :id,          Types::Int.optional.default(nil)
  attribute :origin,      Types::String
  attribute :destination, Types::String
  attribute :value,       Types::Decimal
  attribute :created_at,  Types::DateTime
  attribute :updated_at,  Types::DateTime
end
