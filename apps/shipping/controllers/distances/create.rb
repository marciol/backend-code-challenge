module Shipping::Controllers::Distances
  class Create
    include Shipping::Action

    LOWER_DIST_LIMIT = 0
    HIGH_DIST_LIMIT  = 100_000

    params do
      required(:distance).schema do
        required(:origin).filled(:str?)
        required(:destination).filled(:str?)
        required(:value).filled(:int?, included_in?: LOWER_DIST_LIMIT..HIGH_DIST_LIMIT)
      end
    end

    def initialize(repository: DistanceRepository.new)
      @repository = repository
    end

    def call(params)
      if params.valid?
        @repository.upsert(params[:distance])
        status 200, 'OK'
      else
        status 422, params.error_messages
      end
    end
  end
end
