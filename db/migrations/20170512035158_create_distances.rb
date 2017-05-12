Hanami::Model.migration do
  change do
    create_table :distances do
      primary_key :id

      column :origin, String, null: false
      column :destination, String, null: false
      column :value, Integer, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
