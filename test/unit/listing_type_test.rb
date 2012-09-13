require 'test_helper'

class ListingTypeTest < ActiveSupport::TestCase

  test "should not save invalid listing type" do
    listing_type = Factory.build(:listing_type, :name => nil)
    assert_equal false, listing_type.save
  end
  
  test "should save valid listing type" do
    listing_type = Factory.build(:listing_type)
    assert_equal true, listing_type.save
  end
  
  test "should not destroy listing type with listings" do
    listing_type = Factory.create(:listing_type)
    listing = Factory.create(:listing, :listing_type_id => listing_type.id)
    assert_equal false, listing_type.destroy
  end
  
end
