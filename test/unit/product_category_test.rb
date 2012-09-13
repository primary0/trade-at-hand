require 'test_helper'

class ProductCategoryTest < ActiveSupport::TestCase

  test "should not save invalid product category" do
    product_category = Factory.build(:product_category, :name => nil)
    assert_equal false, product_category.save
  end
  
  test "should save valid product category" do
    product_category = Factory.build(:product_category)
    assert_equal true, product_category.save
  end
  
  test "should not destroy product category with products" do
    product_category = Factory.create(:product_category)
    product = Factory.create(:product, :product_category_id => product_category.id)
    assert_equal false, product_category.destroy
  end
  
end
