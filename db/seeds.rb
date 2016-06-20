require 'bcrypt'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

array = '4;Iné;2016-04-09 17:03:49;2016-04-09 17:03:49
5;Cestoviny;2016-04-09 17:03:49;2016-04-09 17:03:49
6;Bravčové;2016-04-09 17:03:49;2016-04-09 17:03:49
9;Kuracie;2016-04-09 17:03:49;2016-04-09 17:03:49
10;Hovädzie;2016-04-09 17:03:49;2016-04-09 17:03:49
11;Paradajky;2016-04-09 17:03:49;2016-04-09 17:03:49
12;Paprika;2016-04-09 17:03:49;2016-04-09 17:03:49
13;Cibuľa;2016-04-09 17:03:49;2016-04-09 17:03:49
14;Múka;2016-04-09 17:03:49;2016-04-09 17:03:49
15;Zemiaky;2016-04-09 17:03:49;2016-04-09 17:03:49
16;Ryža;2016-04-09 17:03:49;2016-04-09 17:03:49
17;Maslo;2016-04-09 17:03:49;2016-04-09 17:03:49
18;Olej;2016-04-09 17:03:49;2016-04-09 17:03:49
19;Ocot;2016-04-09 17:03:49;2016-04-09 17:03:49
20;Jablká;2016-04-09 17:03:49;2016-04-09 17:03:49
21;Hrušky;2016-04-09 17:03:49;2016-04-09 17:03:49
22;Marhule;2016-04-09 17:03:49;2016-04-09 17:03:49
23;Slivky;2016-04-09 17:03:49;2016-04-09 17:03:49'.split ';'

array.each_slice 4 do |slice|
  Ingredient.create(id: slice[0], name: slice[1], created_at: slice[2], updated_at: slice[3])
end

