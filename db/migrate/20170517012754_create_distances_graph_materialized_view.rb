ROM::SQL.migration do
  up do
  	execute_ddl <<~SQL
  		CREATE MATERIALIZED VIEW distances_graph AS
	      SELECT 
	      	json_object_agg(k, v) as vertexes,
	      	now() updated_at
      	FROM (
	        SELECT 
	        	o k, json_object_agg(d, value) v 
	        FROM (
	          SELECT DISTINCT 
	          	* 
	          FROM (
	            SELECT
	              origin o, destination d, value
              FROM distances
	            UNION ALL
              SELECT 
              	destination o, origin d, value
              FROM distances 
            ) all_distances
	        ) distinct_all_distances GROUP BY o
	      ) json_grouped_distances;
	    CREATE UNIQUE INDEX distances_graph_idx ON distances_graph(updated_at)
  	SQL
  end

  down do
  	execute_ddl <<~SQL
  		DROP MATERIALIZED VIEW distances_graph
  	SQL
  end
end
