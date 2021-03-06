class StoreController < ApplicationController
  skip_before_filter :authorize

  EXCHANGE_RATES = {en: 1, ru: 35}
  
  def index
    if params[:set_locale]
      redirect_to store_path(locale: params[:set_locale])
    else
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
end