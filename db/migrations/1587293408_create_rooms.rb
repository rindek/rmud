# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:rooms) do
      primary_key :id

      String :short, null: false
      String :long, null: false

      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end

    create_table(:room_exits) do
      primary_key :id

      foreign_key :room_id, :rooms
      String :name, null: false
    end
  end
end
