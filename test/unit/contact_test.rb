require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  
  test "should not save invalid contact" do
    contact = Contact.new
    assert_equal false, contact.save
  end
  
  test "should not save contact with self" do
    user = Factory.create(:active_user)
    contact = Contact.new
    contact = user.contacts.build(:associate_id => user.id)
    assert_equal false, contact.save
  end  
  
  test "should save valid contact" do
    user = Factory.create(:active_user)
    associate = Factory.create(:active_user)
    contact = Contact.new
    contact = user.contacts.build(:associate_id => associate.id)
    assert_equal true, contact.save
  end
  
end
