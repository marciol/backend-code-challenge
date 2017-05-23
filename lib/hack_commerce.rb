require_relative './hack_commerce/entity'
require_relative './hack_commerce/repository'

module HackCommerce
  class << self
    attr_accessor :rom_container, :rom_configuration
  end
end
