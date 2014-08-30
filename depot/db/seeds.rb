# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Product.delete_all

Product.create(title: 'Jasmine Oolong Tea',
				description: %{
					This most precious of green oolong teas 
					is made more delicate with the gentle 
					scenting of fragrantly sweet jasmine. 
					Creating a hint of perfumed wonder, this 
					sublime and aromatic hand-rolled tea is 
					nothing less than a cup of transcendental 
					bliss. 
					},
				image_url: 'tea/jasmine.JPG',
				price: 12.98)
Product.create(title: 'Four Seasons Oolong Tea',
				description: %{
					Refreshing and fun, this rolled oolong 
					hails from the renowned Nantou region 
					of Taiwan. Known locally as Si Ji Chun, 
					meaning "four seasons," this full-bodied 
					cup is golden amber in color and pleasantly 
					aromatic, evoking sweet jasmine, lily, 
					and honey. Mellow and fruity with a sweet 
					buttery finish, you will enjoy the delicious 
					taste day or night. 
					},
				image_url: 'tea/fours.JPG',
				price: 17.98)
Product.create(title: 'Toasted Nut Brulee Oolong Tea',
				description: %{
					Savor each sweet sip as this silky modern 
					brûlée channels the decadent scenery of 
					the French Riviera. This sinless oolong 
					tea aims to capture a sweet, sovereign dessert 
					bursting with coconut, cinnamon and caramel. 
					},
				image_url: 'tea/toasted.JPG',
				price: 7.98)