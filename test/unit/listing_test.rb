require 'test_helper'

class ListingTest < ActiveSupport::TestCase

  test "should not save invalid listing" do
    listing = Factory.build(:listing, :price => nil)
    assert_equal false, listing.save
  end
  
  test "should save valid listing" do
    listing = Factory.build(:listing)
    assert_equal true, listing.save
  end
  
  test "should save default expiry date (1 week)" do
    listing = Factory.build(:listing)
    assert_equal true, listing.save
    assert_equal 7.days.from_now.to_date, listing.expiry_date.to_date
  end  
  
end
