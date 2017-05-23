class CreateRouteAndAssociateDistances < ROM::Commands::Create[:sql]
  relation :routes
  register_as :create_and_associate_distances
  result :one

  def execute(tuple)
    result = super

    route_id = result.first[:id]
    stretches.where(route_id: route_id).delete

    if tuple[:distances]
      distances = tuple[:distances].map { |d| d.to_h[:id] }.product([route_id])

      route_tuples = distances.map do |distance_id, route_id|
        { distance_id: distance_id, route_id: route_id }
      end

      stretches.multi_insert(route_tuples)
    end

    result
  end

  def stretches
    relation.stretches
  end
end
