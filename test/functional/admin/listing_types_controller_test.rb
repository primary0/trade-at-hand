require 'test_helper'

class Admin::ListingTypesControllerTest < ActionController::TestCase

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
  
end
