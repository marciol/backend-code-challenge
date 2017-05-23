module Shipping::Controllers::Distances
  class Create
    include Shipping::Action
    accept :txt

    LOWER_DIST_LIMIT = 0
    HIGH_DIST_LIMIT  = 100_000

    params do
      required(:distance).schema do
        required(:origin).filled(:str?)
        required(:destination).filled(:str?)
        required(:value).filled(:int?, included_in?: LOWER_DIST_LIMIT..HIGH_DIST_LIMIT)
      end
    end

    after :refresh_distances_graph

    def initialize(
      repository: DistanceRepository.new, 
      worker: RefreshDistancesGraphWorker)
      @repository = repository
      @worker = worker
    end

    def call(params)
      if params.valid?
        distance, op = @repository.upsert(params[:distance])
        if op == :update 
          distance_with_routes = @repository.find_by_id_with_routes(distance.id)
          if distance_with_routes.routes.any?
            route_ids = distance_with_routes.routes.map(&:id)
            RecalculateDistancesWorker.perform_async(route_ids)
          end
        end
        status 200, 'OK'
      else
        status 422, params.error_messages
      end
    end

    private

    def refresh_distances_graph
      @worker.perform_async
    end
  end
end
