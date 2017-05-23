ROM::SQL.migration do
  change do
    alter_table :distances do
      set_column_default :created_at, Sequel::SQL::Function.new(:now)
      set_column_default :updated_at, Sequel::SQL::Function.new(:now)
    end

    alter_table :routes do
      set_column_default :created_at, Sequel::SQL::Function.new(:now)
      set_column_default :updated_at, Sequel::SQL::Function.new(:now)
    end

    alter_table :stretches do
      set_column_default :created_at, Sequel::SQL::Function.new(:now)
      set_column_default :updated_at, Sequel::SQL::Function.new(:now)
    end
  end
end
