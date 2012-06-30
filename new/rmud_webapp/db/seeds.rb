# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


## Gender
ActiveRecord::Base.connection.execute "TRUNCATE TABLE gender;"

Gender.create!(:name => "meski osobowy", :description => "mezczyzna, elf")
Gender.create!(:name => "meski nieosobowy zywotny", :description => "pies, wilk, dzik")
Gender.create!(:name => "meski nieosobowy niezywotny", :description => "zamek, but, monitor")

Gender.create!(:name => "zenski", :description => "kobieta, elfka, szafka, kuchnia")

Gender.create!(:name => "nijaki osobowy", :description => "dziecko")
Gender.create!(:name => "nijaki nieosobowy", :description => "lozko, krzeslo")


