require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	fixtures :products
	test "product attributes must not be empty" do
		product = Product.new
		assert product.invalid?
		assert product.errors[:title].any?
		assert product.errors[:description].any?
		assert product.errors[:price].any?
		assert product.errors[:image_url].any?
	end
	test "product price must be positive" do
		product = Product.new(title: 'Test 02',
								description: 'Test 02',
								image_url: '123.gif')
		product.price = -1
		assert product.invalid?
		assert_equal "must be greater than or equal to 0.01",
						product.errors[:price].join('; ')

		product.price = 0.001
		assert product.invalid?
		assert_equal "must be greater than or equal to 0.01",
						product.errors[:price].join('; ')
		product.price = 0.01
		assert product.valid?
	end
	test "" do
		def new_product(image_url)
			Product.new(title: 'Test 03',
						description: 'Test 03',
						price: 1,
						image_url: image_url)
		end

		ok = %w{ fred.gif fred.jpg fred.PNG fReD.jPg http://one.two/a/b/c/fred.GIF}
		not_ok = %w{ fred.doc fred.gif/one fred.gif.more }

		ok.each do |name|
			assert new_product(name).valid?, "#{name} should be valid"
		end
		not_ok.each do |name|
			assert new_product(name).invalid?, "#{name} shouldn't be valid"
		end
	end
	test "product is not valid without a unique title" do
		product = Product.new(title: products(:jasmine).title,
			description: "123",
			price: 1,
			image_url: "my.gif")

		assert !product.save
		assert_equal "has already been taken", product.errors[:title].join('; ')
	end
	test "product title should be longer than 6 characters" do
		product = Product.new(title: 'abcde',
			description: "123",
			price: 1,
			image_url: "my.gif")
		assert !product.save, "should not save product with short title"
		product.title += 'f'
		assert product.save, "should save product with proper title"
	end
end
