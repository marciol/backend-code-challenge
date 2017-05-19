ROM::SQL.migration do
  change do
    create_table :stretches do
      primary_key :id
      foreign_key :route_id, :routes, on_delete: :cascade, null: false
      foreign_key :distance_id, :distances, on_delete: :cascade, null: false
      index [:route_id, :distance_id], unique: true

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
