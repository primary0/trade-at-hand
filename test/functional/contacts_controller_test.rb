require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  
  test "should not add contact without session" do
    post :create, :params => {}
    assert_redirected_to new_user_session_url
  end
  
  test "should add contact with session" do
    user = Factory.create(:active_user)
    associate = Factory.create(:associate)
    UserSession.create(user)
    post :create, :associate_id => associate.id
    assert_redirected_to user_url(user)
  end
    
end
