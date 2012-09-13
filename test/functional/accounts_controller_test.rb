require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  
  def setup
    @active_user = Factory.create(:active_user)
    @inactive_user = Factory.create(:inactive_user)
  end
  
  # Displaying activation form
  
  test "should show activation form" do
    get :activation
    assert :success
  end

  # Activation
  
  test "should activate valid inactive user" do
    user = Factory.create(:user)
    post :activate, {:phone => user.phone, :activation_code => user.perishable_token}
    #assert_redirected_to root_url
  end

  test "should not activate active user" do
    post :activate, {:phone => @active_user.phone, :activation_code => @active_user.perishable_token}
    assert_template "activation"
  end
  
  test "should not activate unregistered phone numbers" do
    attributes = {:phone => "99999", :activation_code => "99999"}
    post :activate, attributes
    assert_template "activation"    
  end
  
  # Forgot password step 1.
  
  test "should show forgot password form" do
    get :forgot_password
    assert :success
  end
  
  # Sending password reset instructions
    
  test "should send password rest instructions for active user" do
    post :send_password_reset_instructions, {:phone => @active_user.phone}
    assert_redirected_to root_url
  end
  
  test "should not send password reset instructions for inactive user" do
    post :send_password_reset_instructions, {:phone => @inactive_user.phone}
    assert_template "forgot_password"    
  end
  
  test "should not send password reset instructions for invalid user" do
    attributes = {:phone => "99999", :activation_code => "99999"}    
    post :send_password_reset_instructions, attributes
    assert_template "forgot_password"    
  end
  
  # Displaying password reset page
  
  test "should show reset password page for active users" do
    get :reset_password_confirmation, {:user => @active_user.phone, :token => @active_user.perishable_token}
    assert :success
  end
  
  test "should not show reset password page for inactive users" do
    get :reset_password_confirmation, {:user => @inactive_user.phone, :token => @inactive_user.perishable_token}
    assert_template "forgot_password"
  end
  
  test "should not show reset password page for invalid users" do
    attributes = {:phone => "99999", :activation_code => "99999"}        
    get :reset_password_confirmation, attributes
    assert_template "forgot_password"
  end
  
  # Setting a new password
  
  test "should set new password for active users" do
    attributes = Factory.attributes_for(:user, :active => true)
    post :reset_password, :phone => @active_user.phone, :token => @active_user.perishable_token, :user => attributes
    assert_redirected_to new_user_session_url
  end
  
  test "should not set new password for inactive users" do
    post :reset_password, :phone => @inactive_user.phone, :token => @inactive_user.perishable_token, :user => @inactive_user
    assert_template "forgot_password"
  end  
  
  test "should not set new password for invalid users" do   
    post :reset_password, {:phone => "99999", :activation_code => "99999"}, :user => {:password => "welcome", :password_confirmation => "welcome"}
    assert_template "forgot_password"
  end
    
end
