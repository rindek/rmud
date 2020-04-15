# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:players) do
      primary_key :id
      String :name, null: false
      String :password, null: false

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
