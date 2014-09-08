require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:cema)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get new with no auth if no users in DB" do
    logout    # logout current user
    User.delete_all   # delete all users

    get :new
    assert_response :success
  end 

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { name: 'Test_User', password: 'pass', password_confirmation: 'pass' }
    end

    assert_redirected_to users_path
  end

  test "should create user with no auth if no users in DB" do
    logout    # logout current user
    User.delete_all   # delete all users

    assert_difference('User.count') do
      post :create, user: { name: 'Test_User', password: 'pass', password_confirmation: 'pass' }
    end

    assert_redirected_to users_path
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should not update user" do
    patch :update, id: @user, user: 
      { name: 'Cema_', old_password: '123', 
        password: 'pass_', password_confirmation: 'pass_' }
    assert_response :success
    assert_equal "Enter valid user password", flash[:notice]
  end

  test "should update user" do
    patch :update, id: @user, user: 
      { name: 'Cema_', old_password: 'pass', 
        password: 'pass_', password_confirmation: 'pass_' }
    assert_redirected_to users_path
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
