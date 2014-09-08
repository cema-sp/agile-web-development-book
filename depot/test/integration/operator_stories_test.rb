require 'test_helper'

class OperatorStoriesTest < ActionDispatch::IntegrationTest
	test "shipping order" do
		# operator opens login page
		get '/login'
		assert_response :success
		# operator enters login and password and presses submit
		cema = users(:cema)
		post_via_redirect '/login', name: cema[:name], password: 'pass'
		assert_response :success
		# and admin page opens
		assert_template 'admin/index'
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

	test "changing user data" do
		# operator opens login page
		get '/login'
		assert_response :success
		# he logins
		cema = users(:cema)
		post_via_redirect '/login', name: cema[:name], password: 'pass'
		assert_response :success
		# he goes to users page
		get '/users'
		assert_response :success
		# he finds his user
		assert_select "tr td", /Cema/
		# he opens update page
		get "/users/#{cema.id}/edit"
		assert_response :success
		assert_template 'edit'
		# he sees old_password field
		assert_select "input[type=password]#user_old_password"
		# and changes current password (fail)
		patch "/users/#{cema.id}", user: {name: 'Cema_', 
			old_password: '', password: 'pass_', 
			password_confirmation: 'pass_'}
		assert_response :success
		assert_equal "Enter valid user password", flash[:notice]
		# and changes current password (success)
		patch "/users/#{cema.id}", user: {name: 'Cema_', 
			old_password: 'pass', password: 'pass_', 
			password_confirmation: 'pass_'}
		assert_redirected_to users_url
	end
end
