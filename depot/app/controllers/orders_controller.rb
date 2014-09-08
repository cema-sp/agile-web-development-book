class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :ship]
  skip_before_filter :authorize, only: [:new, :create]

  # GET /orders
  # GET /orders.json
  def index
    # @orders = Order.all
    @orders = Order.order('created_at asc').paginate(page: params[:page], 
                              per_page: 10)

    respond_to do |format|
      format.html
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @cart = current_cart
    if @cart.line_items.empty?
      redirect_to store_url, notice: 'Your cart is empty'
      return
    end
    @order ||= Order.new
    payment_types
  end

  # GET /orders/1/edit
  def edit
    @cart = current_cart
    payment_types
  end

  # POST /orders
  # POST /orders.json
  def create
    pay_type = PayType.find(order_params[:pay_type_id]) rescue nil
    unless pay_type
      @order = Order.new(order_params)
      @order.valid?
      payment_types
      render :new
      return
    end


    @order = pay_type.orders.build(order_params)
    # @order = Order.new(order_params)
    @order.add_line_items_from_cart(current_cart)
    # @cart = current_cart

    respond_to do |format|
      if @order.save
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        OrderNotifier.received(@order).deliver

        format.html { redirect_to store_url, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        @cart = current_cart
        payment_types
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def ship
    respond_to do |format|
      if @order.update({ship_date: Time.now}) #.save
        OrderNotifier.shipped(@order).deliver
        format.html { redirect_to orders_url, notice: 'Order was shipped successfully' }
      else
        format.html { redirect_to orders_url, notice: 'Order was not shipped! Something went wrong.' }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type_id)
    end

    def payment_types
      @payment_types = PayType.all.map do |pay_type| 
        [pay_type.type, pay_type.id]
      end
    end
end
