class DistanceRepository < Hanami::Repository
	def upsert(**args)
		origin, destination = args.values_at(:origin, :destination)
		if distance = distances.where(origin: origin, destination: destination).first	
			update(distance.id, args)
		else
			create(args)
		end
	end
end
