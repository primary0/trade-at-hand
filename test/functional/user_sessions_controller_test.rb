require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  
  def setup
    @active_user = Factory.create(:active_user)
    @inactive_user = Factory.create(:inactive_user)
  end
    
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should create a new session" do
    post :create, :user_session => {:phone => @active_user.phone, :password => @active_user.password}
    assert user_session = UserSession.find
    assert_equal @active_user, user_session.user
    assert_redirected_to root_url    
  end
  
  test "should not create session with inactive user" do
    post :create, :user_session => {:phone => @inactive_user.phone, :password => @inactive_user.password}
    assert_nil user_session = UserSession.find
    assert_template "new"
  end  
  
  test "should not create a new session with invalid password" do
    post :create, :user_session => {:phone => @active_user.phone, :password => "wrong"}
    assert_template "new"   
  end
  
  test "should not destroy nonexistent user session" do
    delete :destroy
    assert_redirected_to new_user_session_url
  end
  
  test "should destroy existing user session" do
    post :create, :user_session => {:phone => @active_user.phone, :password => @active_user.password}
    assert user_session = UserSession.find
    assert_equal @active_user, user_session.user    
    delete :destroy
    assert flash[:notice]
  end
   
end