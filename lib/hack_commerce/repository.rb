require 'rom-repository'

module HackCommerce

  class Repository < ROM::Repository::Root

    module Types
      include Dry::Types.module
    end

    def self.inherited(klass)
      super

      klass.singleton_class.class_eval do
        attr_accessor :entity_class, :entity_name
      end

      klass.class_eval do
        commands :create, update: :by_pk, delete: :by_pk, use: [:timestamps], mapper: :entity

        def self.entity(entity_class)
          self.entity_class = entity_class
          self.entity_name = entity_class.to_s
        end
      end

    end

    def initialize(container = HackCommerce.rom_container)
      super(container)
    end

    def find(id)
      root.by_pk(id).as(:entity).one
    end

    def all
      root.as(:entity).to_a
    end

    def first
      root.as(:entity).limit(1).one
    end

    def last
      root.as(:entity).limit(1).reverse.one
    end

    def clear
      root.delete
    end

    def entity
      self.class.entity_class
    end
  end
end
