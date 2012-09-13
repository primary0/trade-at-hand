require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @active_user = Factory.create(:active_user)
    @inactive_user = Factory.create(:inactive_user)
    @valid_attributes = Factory.attributes_for(:user)
    @invalid_attributes = Factory.attributes_for(:invalid_user)
  end
  
  test "should get registration form" do
    get :new
    assert assigns(:user)
    assert_response :success
  end
  
  test "should create new user" do
    assert_difference('User.count') do
      post :create, :user => @valid_attributes
    end
    assert_redirected_to activation_account_url
  end

  test "should not create invalid user" do
    assert_no_difference('User.count') do
      post :create, :user => @invalid_attributes
    end
    assert_template "new"
  end
  
  test "should show user profile" do
    get :show, :id => @active_user
    assert assigns(:user)
    assert_response :success
  end
  
  test "should not show inactive user profile" do
    get :show, :id => @inactive_user
    assert_redirected_to root_url
  end
    
  test "should show edit form" do 
    UserSession.create(@active_user)
    get :edit
    assert assigns(:user)
    assert_response :success
  end
  
  test "should not show edit form without session" do  
    get :edit
    assert_nil assigns(:user)
    assert_redirected_to new_user_session_url
  end
  
  test "should update user" do     
    UserSession.create(@active_user)
    put :update, :id => @active_user, :user => {}
    assert_redirected_to user_path(@active_user)
  end
  
  test "should not update user without session" do
    put :update, :id => @active_user, :user => {}
    assert_redirected_to new_user_session_url  
  end
  
end