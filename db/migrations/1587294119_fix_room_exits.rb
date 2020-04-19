# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:room_exits) do
      rename_column :room_id, :from_room_id
      add_foreign_key :to_room_id, :rooms
    end
  end
end
