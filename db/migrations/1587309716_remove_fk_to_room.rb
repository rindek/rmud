# frozen_string_literal: true

Sequel.migration do
  change do
    alter_table(:room_exits) do
      drop_foreign_key [:to_room_id]
    end

    run %(ALTER TABLE room_exits ALTER COLUMN to_room_id TYPE text)
  end
end
