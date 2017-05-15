require 'hanami/action/cache'
require 'digest'

module Shipping::Controllers::Costs
  class Show
    include Shipping::Action
    include Hanami::Action::Cache
    accept :txt

    params do
      required(:origin).filled(:str?)
      required(:destination).filled(:str?)
      required(:weight).filled(:float?)
    end

    def initialize(repository: DistanceRepository.new)
      @repository = repository
    end

    def call(params)
      if params.valid?
        value = calculate_cost(params)
        status 200, value.to_s('F')
      else
        status 422, params.error_messages
      end
    rescue ArgumentError => e
      status 422, e.message
    end

    private

    def calculate_cost(params)
      origin = Location.new(repository: @repository, name: params[:origin])
      destination = Location.new(repository: @repository, name: params[:destination])
      @distances = origin.shortest_path(destination)

      fresh etag: etag

      cost = Cost.new(distances: @distances, weight: params[:weight])
      cost.calculate
    end

    def etag
      value = md5(@distances.map(&:updated_at).join("-"))
      "W/#{value}"
    end

    def md5(value)
      md5 = Digest::MD5.new
      md5.update(value)
      md5.hexdigest
    end
  end
end
