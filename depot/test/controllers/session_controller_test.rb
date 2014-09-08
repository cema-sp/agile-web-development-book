require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    get :new
    assert_response :success
    cema = users(:cema)
    post :create, name: cema.name, password: 'pass'
    assert_redirected_to admin_url
    assert_equal cema.id, session[:user_id]
  end

  test "should fail login" do
    get :new
    assert_response :success
    cema = users(:cema)
    post :create, name: cema.name, password: 'wrong'
    assert_redirected_to login_url
    assert_equal "Wrong credentials!", flash[:alert]
  end

  test "should redirect to new user if no users in DB" do
    logout  # logout current user (cema)
    User.delete_all   # delete all users from DB

    get :new
    assert_redirected_to new_user_url
  end

  test "should logout" do
    delete :destroy
    assert_redirected_to store_url
    assert_nil session[:user_id]
  end

end
