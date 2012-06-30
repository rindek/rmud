migration 1, :add_accounts_table do
  up do
    create_table :accounts do
      column :id, Integer, :serial => true
      column :name, String, :size => 50, :allow_nil => true, :default => nil
      column :email, String, :size => 50, :allow_nil => true, :default => nil
      column :password, Text
      column :password_confirmation, Text
    end
  end
  down do
    drop_table :accounts
  end
end
