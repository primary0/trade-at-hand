require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  
  test "should not save invalid product" do
    product = Factory.build(:product, :name => nil)
    assert_equal false, product.save
  end
  
  test "should save valid product" do
    product = Factory.create(:product)
    assert_equal true, product.save
  end
  
  test "should not delete product with listings" do
    product = Factory.create(:product)
    listing = Factory.create(:listing, :product_id => product.id)
    assert_equal false, product.destroy
  end  
  
end
