require 'test_helper'

class MeasuringSystemTest < ActiveSupport::TestCase

  test "should not save measuring systep" do
    measuring_system = Factory.build(:measuring_system, :name => nil)
    assert_equal false, measuring_system.save
  end
  
  test "should save valid measuring system" do
    measuring_system = Factory.build(:measuring_system)
    assert_equal true, measuring_system.save
  end
  
  test "should not destroy measuring system with listings" do
    measuring_system = Factory.create(:measuring_system)
    listing = Factory.create(:listing, :measuring_system_id => measuring_system.id)
    assert_equal false, measuring_system.destroy
  end
  
  test "should not destroy measuring system with products" do
    measuring_system = Factory.create(:measuring_system)
    product = Factory.create(:product)
    product.measuring_systems<<measuring_system
    assert_equal false, measuring_system.destroy
  end  
  
end
