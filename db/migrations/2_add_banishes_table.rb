migration 2, :add_banishes_table do
  up do
    create_table :banishes do
      column :id, Integer, :serial => true
      column :name, String, :size => 50, :allow_nil => true, :default => nil
      column :reason, Text
      column :created_at, DateTime
      column :banisheer_id, Integer
    end
  end
  down do
    drop_table :banishes
  end
end
