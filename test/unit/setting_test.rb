require 'test_helper'

class SettingTest < ActiveSupport::TestCase

  test "should not save invalid setting" do
    setting = Factory.build(:setting, :name => nil)
    assert_equal false, setting.save
  end
  
  test "should save valid setting" do
    setting = Factory.build(:setting)
    assert_equal true, setting.save
  end

end
