class DistanceRepository < HackCommerce::Repository[:distances]
  relations :routes
  entity Distance

  def upsert(**args)
    origin, destination = args.values_at(:origin, :destination)
    result, operation = if distance = distances.where(origin: origin, destination: destination).first
                          res = update(distance.id, args)
                          [res, :update]
                        else
                          res = create(args)
                          [res, :create]
                        end
    [result, operation]
  end

  def find_by_id_with_routes(distance_id)
    distances.by_pk(distance_id).combine(:routes).one
  end

  def load_vertexes
    rel = root.read <<~SQL
      SELECT json_object_agg(k, v) as vertexes FROM (
        SELECT o k, json_object_agg(d, value) v FROM (
          SELECT DISTINCT * FROM (
            SELECT
              origin o, destination d, value
              FROM distances
            UNION ALL
              SELECT destination o, origin d, value
              FROM distances ) all_distances
        ) distinct_all_distances GROUP BY o
      ) json_grouped_distances
    SQL
    rel.last[:vertexes]
  end

  def by_origin(*names)
    distances.as(:entity).where(origin: names)
  end

  def find_by_origin(name)
    by_origin(name).limit(1).first
  end

  def find_by_origin_and_destination(origin, destination)
    distances.as(:entity).where(origin: origin, destination: destination).first
  end
end
