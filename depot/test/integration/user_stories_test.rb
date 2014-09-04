require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
	test "product purchase" do
		LineItem.delete_all
		Order.delete_all
		jasmine_tea = products(:jasmine)
		pay_check = pay_types(:check)
		# user opens store page
		get "/"
		assert_response :success
		assert_template "index"
		# he chooses product adding it to the cart
		xml_http_request :post, '/line_items', 
			product_id: jasmine_tea.id
		assert_response :success
		
		cart = Cart.find(session[:cart_id])
		assert_equal 1, cart.line_items.size
		assert_equal jasmine_tea, cart.line_items.first.product
		# then he places the order
		get "/orders/new"
		assert_response :success
		assert_template "new"
		# then he fills the form and presses "@"Submit"
		post_via_redirect "/orders",
			order: { name: "Cema", 
				address: "Moscow",
				email: "cema@cema.com",
				pay_type_id: pay_check.id}
		assert_response :success
		assert_template "index"
		# meanwhile cart becomes empty
		cart = Cart.find(session[:cart_id])
		assert_equal 0, cart.line_items.size
		# as result, new order and line_item are present in DB
		orders = Order.all
		assert_equal 1, orders.size
		order = orders.first

		assert_equal "Cema", order.name
		assert_equal "Moscow", order.address
		assert_equal "cema@cema.com", order.email
		assert_equal "Check", order.pay_type.type

		assert_equal 1, order.line_items.size
		line_item = order.line_items.first
		assert_equal jasmine_tea, line_item.product
		# and email sent
		mail = ActionMailer::Base.deliveries.last
		assert_equal ["cema@cema.com"], mail.to
		assert_equal "Cema <cema@example.com>", mail[:from].value
		assert_equal "Cema's Tea Shop order notification", mail.subject
	end
end
