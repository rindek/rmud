migration 4, :add_players_table do
  up do
    create_table :players do
      column :id, Integer, :serial => true
      column :name, String, :size => 50, :allow_nil => true, :default => nil
      column :created, Boolean
      column :created_at, DateTime
      column :account_id, Integer
      column :declension_nazwa, String, :allow_nil => true, :default => nil
    end
  end

  down do
    drop_table :players
  end
end

