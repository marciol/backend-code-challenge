class DistancesGraphRepository < ROM::Repository[:distances_graphs]
#  self.relation = :distances_graph
#
#	def graph
#		distances_graph.first
#	end
#
#	def refresh_graph
#		db_conn.refresh_view(relation_name, concurrently: true)
#	end
#
#	private
#
#	def relation_name
#		self.class.relation
#	end
#
#	def db_conn
#		self.class.container.gateways[:default].connection
#	end
end
