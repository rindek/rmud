migration 3, :add_declension_table do
  up do
    create_table :declensions do
      column :nazwa, String, :size => 150

      [:mianownik, :dopelniacz, :celownik, :biernik, :narzednik, :miejscownik].each do |c|
        column c, String, :size => 150, :allow_nil => true, :default => nil
      end

      column :rodzaj, Integer
    end
  end
  down do
    drop_table :declensions
  end
end
