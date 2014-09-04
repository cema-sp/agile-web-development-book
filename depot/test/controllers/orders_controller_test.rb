require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:daves_order)
  end

  test "require item in cart" do
    get :new
    assert_redirected_to store_path
    assert_equal flash[:notice], 'Your cart is empty'
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    cart = Cart.create
    session[:cart_id] = cart.id
    cart.line_items.create(product: products(:jasmine))
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, order: { address: @order.address, email: @order.email, name: @order.name, pay_type_id: pay_types(:card).id }
    end

    assert_redirected_to store_path # order_path(assigns(:order))
  end

  test "should show order" do
    get :show, id: @order
    assert_response :success
  end

  test "should get edit" do
    @cart = Cart.create
    session[:cart_id] = @cart.id
    @cart.line_items.create(product: products(:jasmine))

    @payment_types = PayType.all.map do |pay_type| 
        [pay_type.type, pay_type.id]
    end
    get :edit, id: @order
    assert_response :success
  end

  test "should update order" do
    patch :update, id: @order, order: { address: @order.address, email: @order.email, name: @order.name, pay_type: @order.pay_type }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order
    end

    assert_redirected_to orders_path
  end
end
