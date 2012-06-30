class Player < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name, :null => false
      t.belongs_to :account
      t.belongs_to :dictionary
      t.datetime :last_login

      t.timestamps
    end
  end
end
