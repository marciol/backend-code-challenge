class DistancesGraphRepository < HackCommerce::Repository[:distances_graph]
  entity DistancesGraph

  def graph
		distances_graph.first
	end

	def refresh_graph
		db_conn.refresh_view(relation_name, concurrently: true)
	end

	private

	def relation_name
    root.name.to_s
	end

	def db_conn
		container.gateways[:default].connection
	end
end
