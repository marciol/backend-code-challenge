class DistanceRepository < Hanami::Repository
  def upsert(**args)
    origin, destination = args.values_at(:origin, :destination)
    if distance = distances.where(origin: origin, destination: destination).first 
      update(distance.id, args)
    else
      create(args)
    end
  end

  def load_vertexes
  	rel = root.read <<~SQL
  		WITH all_distances AS (
				SELECT 
				origin o, destination d, value
				FROM distances
				UNION ALL
				SELECT destination o, origin d, value
				FROM distances
  		), 
  		distinct_all_distances AS (
  			SELECT DISTINCT * FROM all_distances
  		),
		  json_grouped_distances AS (
				SELECT o k, json_object_agg(d, value) v
				FROM distinct_all_distances GROUP BY o
  		) SELECT json_object_agg(k, v) as vertexes FROM json_grouped_distances 
  	SQL
  	rel.last[:vertexes]
  end

  def by_origin(*names)
  	distances.where(origin: names)
  end

  def find_by_origin(name)
  	by_origin(name).limit(1).first
  end

  def find_by_origin_and_destination(origin, destination)
  	distances.where(origin: origin, destination: destination).first
  end
end
