require 'dry-types'
require 'dry-struct'

module HackCommerce
  class Entity < Dry::Struct
    module Types
      include Dry::Types.module
    end
  end
end
