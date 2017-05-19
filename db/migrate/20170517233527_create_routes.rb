ROM::SQL.migration do
  change do
    create_table :routes do
      primary_key :id
      column :origin, String, null: false
      column :destination, String, null: false
      index [:origin, :destination], unique: true

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
