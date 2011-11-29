migration 5, :fix_players_table do
  up do
    modify_table :accounts do
      rename_column :password_confirmation, :player_password 
    end
  end

  down do
    modify_table :accounts do
      rename_column :player_password, :password_confirmation
    end
  end
end
