class SessionController < ApplicationController
  skip_before_filter :authorize

  def new
    if User.count.zero?
      redirect_to new_user_url
    end
  end

  def create
  	user = User.find_by_name(params[:name])
  	if user and user.authenticate(params[:password])
  		session[:user_id] = user.id
  		redirect_to admin_url
  	else
  		redirect_to login_url, alert: 'Wrong credentials!'
  	end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to store_url, notice: 'Session destroyed.'
  end
end
