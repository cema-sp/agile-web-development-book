class StoreController < ApplicationController
  def index
  	@products = Product.order(:title)

  	if session[:counter].nil?
  		@session_counter = 1
  	else
  		@session_counter = session[:counter].to_i + 1
  	end
  	session[:counter] = @session_counter
  	 			
  end
end
