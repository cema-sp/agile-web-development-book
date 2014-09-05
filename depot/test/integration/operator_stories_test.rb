require 'test_helper'

class OperatorStoriesTest < ActionDispatch::IntegrationTest
	test "shipping order" do
		# operator opens orders view
		get '/orders'
		assert_response :success
		assert_template 'index'
		# he finds required order
		daves_order = orders(:daves_order)
		assert_select "tr>td", /#{daves_order[:name]}/
		# than he pushes "Ship" button
		get_via_redirect "/orders/#{daves_order[:id]}/ship"
		# and receives success message
		assert_response :success
		assert_template 'index'
		assert_equal "Order was shipped successfully", flash[:notice]
		assert_select '#notice', /Order was shipped successfully/
		# meanwhile order obtains ship_time
		order = Order.find(daves_order[:id])
		assert_not_nil order[:ship_date]
		# and email is being sent
		mail = ActionMailer::Base.deliveries.last
		assert_equal "Cema's Tea Shop order shipped", mail.subject
		assert_equal ["dave@domain.com"], mail.to
		assert_equal "Cema <cema@example.com>", mail[:from].value
		
	end
end
