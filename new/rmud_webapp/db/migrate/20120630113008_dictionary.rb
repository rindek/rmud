class Dictionary < ActiveRecord::Migration
  def change
    create_table :dictionary do |t|
      t.string :nominative
      t.string :genitive
      t.string :dative
      t.string :accusative
      t.string :instrumental
      t.string :locative

      t.string :plu_nominative
      t.string :plu_genitive
      t.string :plu_dative
      t.string :plu_accusative
      t.string :plu_instrumental
      t.string :plu_locative

      t.belongs_to :gender
    end
  end
end
