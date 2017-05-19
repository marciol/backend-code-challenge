require 'rom-repository'

module HackCommerce

  class Repository < ROM::Repository::Root
    commands :create, :update

    module Types
      include Dry::Types.module
    end

    def initialize(container = HackCommerce.rom_container)
      super(container)
    end

    def clear
      root.delete
    end
  end
end
