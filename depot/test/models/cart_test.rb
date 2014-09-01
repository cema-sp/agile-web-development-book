require 'test_helper'

class CartTest < ActiveSupport::TestCase
	def setup
		@cart = Cart.new
	end
	test "cart should be created" do
		assert @cart.valid?
	end
	test "cart should build line items" do
		line_item = @cart.line_items.build(product_id: 1)
		line_item.save
		assert line_item.valid?
	end
	test "cart should add distinct product" do
		line_item = @cart.add_product(products(:jasmine).id)
		line_item.save
		assert line_item.valid?
	end
	test "cart should add quantity to line item" do
		line_item_1 = @cart.add_product(products(:jasmine).id)
		line_item_1.save
		line_item_2 = @cart.add_product(products(:jasmine).id)
		line_item_2.save
		assert_equal line_item_1.id, line_item_2.id
		assert_equal 1, @cart.line_items.size
		assert_equal 2, line_item_2.quantity
	end
	test "cart should add product and copy price" do
		line_item = @cart.add_product(products(:jasmine).id)
		line_item.save
		assert_equal products(:jasmine).price, line_item.price
	end
	test "should calculate total price" do
		line_item_1 = @cart.add_product(products(:jasmine).id)
		line_item_1.save
		line_item_2 = @cart.add_product(products(:jasmine).id)
		line_item_2.save
		line_item_3 = @cart.add_product(products(:fours).id)
		line_item_3.save
		assert_equal((line_item_2.total_price+line_item_3.total_price),
			@cart.total_price)
	end
end
