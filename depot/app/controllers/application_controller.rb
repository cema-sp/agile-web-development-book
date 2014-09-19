class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authorize
  before_filter :set_i18n_locale_from_params

  
  LANGUAGES = [['English', 'en'],
      ["Русский",'ru']]

  protected

  def authorize
    unless User.find_by_id(session[:user_id])
      # respond_to do |format|
      if request.format == Mime::HTML
        # format.html { 
          redirect_to(login_url, notice: 'Please, login first.') 
        # }
      else
        # format.all do
          authenticate_or_request_with_http_basic("Depot") do |login, password|
            user = User.find_by_name(login)
            user && user.authenticate(password)
          end
        # end
      end
    end
  end

  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = 
          "#{params[:locale].upcase} translation not avaliable"
        logger.error flash.now[:notice]
      end
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end

  private

  def current_cart
  	Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
  	cart = Cart.create
  	session[:cart_id] = cart.id
  	cart
  end
end
