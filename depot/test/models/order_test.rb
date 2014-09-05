require 'test_helper'

class OrderTest < ActiveSupport::TestCase
	test "should have ship_time field" do
		order = Order.new
		assert order.has_attribute?(:ship_date)
	end
end