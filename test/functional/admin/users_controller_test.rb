require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase

  def setup
    @admin = Factory.create(:admin)
    UserSession.create(@admin)    
  end
  
  test "should not show index page unless an admin" do
    session = UserSession.find
    session.destroy
    get :index
    assert_redirected_to root_url
  end
  
  test "get index" do
    get :index
    assert assigns(:users)
    assert assigns(:inactive_users)
  end
  
  # Admin user activation and deactivation
  
  test "should deactivate user" do
    user = Factory.create(:active_user)
    put :deactivate, :id => user
    assert_equal "information", flash[:type]
  end
  
  test "should not deactivate user" do
    user = Factory.create(:inactive_user)
    put :deactivate, :id => user
    assert_equal "error", flash[:type]
  end  
  
  test "should activate user" do
    user = Factory.create(:inactive_user)
    put :activate, :id => user
    assert_equal "information", flash[:type]
  end
  
  test "should not activate user" do
    user = Factory.create(:active_user)
    put :activate, :id => user
    assert_equal "error", flash[:type]
  end  
  
end
