require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "should not save invalid user" do
    invalid_user = Factory.build(:invalid_user)
    assert_equal false, invalid_user.save
  end
  
  test "should save valid user" do
    user = Factory.build(:user)
    assert_equal true, user.save
  end
  
  test "should not delete user with listings" do
    user = Factory.create(:user)
    listing = Factory.create(:listing, :user_id => user.id)
    assert_equal false, user.destroy
  end
  
  test "should not activate active user" do
    user = Factory.create(:active_user)
    assert_equal false, user.activate!
  end
  
  test "should not deactivate inactive user" do
    user = Factory.create(:inactive_user)
    assert_equal false, user.deactivate!
  end
  
end
