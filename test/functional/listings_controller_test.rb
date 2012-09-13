require 'test_helper'

class ListingsControllerTest < ActionController::TestCase
  
  def setup
    @listing = Factory.create(:listing)
    @user = Factory.create(:active_user)
  end
  
  test "should show index" do
    get :index
    assert assigns(:listings)
    assert :success
  end
  
  test "should show listing" do
    get :show, :id => @listing
    assert assigns(:listing)
    assert :success
  end
  
  test "should not show new listing page without session" do
    get :new
    assert_redirected_to new_user_session_url
  end
  
  test "should show new listing page" do    
    UserSession.create(@user)
    get :new
    assert_response :success    
  end
  
  test "should not show edit listing page without session" do
    get :edit, :id => @listing
    assert_redirected_to new_user_session_url
  end
  
  test "should not show edit listing page if not owner" do
    owner = Factory.create(:active_user)
    @listing.user = owner
    UserSession.create(@user)    
    get :edit, :id => @listing
    assert_redirected_to listing_url(@listing)
  end
  
  test "shoud show edit listing page for listing owner" do
    @listing.user = @user
    @listing.save
    UserSession.create(@user)    
    get :edit, :id => @listing
    assert assigns(:listing)
    assert_response :success
  end
  
  test "should not create new listing without session" do
    listing = Factory.build(:listing)
    post :create, :listing => {}
    assert_redirected_to new_user_session_url
  end

end
