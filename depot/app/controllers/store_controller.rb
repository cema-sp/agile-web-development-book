class StoreController < ApplicationController
  skip_before_filter :authorize
  
  def index
  	@products = Product.order(:title)
    @cart = current_cart

  	if session[:counter].nil?
  		@session_counter = 1
  	else
  		@session_counter = session[:counter].to_i + 1
  	end
  	session[:counter] = @session_counter
  	 			
  end
end
