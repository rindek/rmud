class Gender < ActiveRecord::Migration
  def change
    create_table :gender do |t|
      t.string :name
      t.string :description
    end
  end
end
