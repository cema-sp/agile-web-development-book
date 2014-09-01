require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
	test "line item should be created" do
		line_item = LineItem.new(cart_id: 1, product_id: 1)
		assert line_item.valid?
	end
	test "line item should count total price" do
		line_item = LineItem.new(cart_id: 1, 
			product_id: products(:jasmine).id, quantity: 2)
		assert_equal 2*products(:jasmine).price, 
			line_item.total_price
	end
end
