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
  		SELECT json_object_agg(origin, o) as vertexes
			FROM (
				SELECT origin, json_object_agg(destination, value) as o
				FROM distances GROUP BY origin
			) s
  	SQL
  	rel.last[:vertexes]
  end

  def by_origin(*names)
  	distances.where(origin: names)
  end

  def find_by_origin(name)
  	by_origin(name).limit(1).first
  end
end
