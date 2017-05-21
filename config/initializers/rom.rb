require 'rom'
require 'rom-sql'
require_relative './rom/plugins.rb'

configuration = ROM::Configuration.new(
  :sql, 
  ENV['DATABASE_URL'], 
  extensions: [:pg_json]
).tap do |config|

  config.auto_registration('./lib/hack_commerce', namespace: false)

  config.mappers do
    define(:distances) do
      model Distance
      register_as :entity
    end

    define(:stretches) do
      model Stretch
      register_as :entity
    end

    define(:distances_graph) do
      model DistancesGraph
      register_as :entity
    end

    define(:routes) do
      model Route
      register_as :entity
    end
  end
end

HackCommerce.rom_container = ROM.container(configuration)
HackCommerce.rom_configuration = configuration
