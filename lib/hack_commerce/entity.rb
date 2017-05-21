require 'dry-types'
require 'dry-struct'
require 'dry-monads'

module HackCommerce
  class Entity < Dry::Struct
    constructor_type :schema

    Dry::Types.load_extensions(:maybe)

    module Types
      include Dry::Types.module
    end

    def self.inherited(klass)
      super
      klass.class_eval do
        attribute :created_at,  Types::DateTime.default { DateTime.now }
        attribute :updated_at,  Types::DateTime.default { DateTime.now }
      end
    end
  end
end
