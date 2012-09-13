class Contact < ActiveRecord::Base
  belongs_to :user
  belongs_to :associate, :class_name => "User"
  validates_presence_of :associate_id, :user_id
  
  validates_uniqueness_of :associate_id, :scope => [:user_id], :messages => "Contact is already added."
  
  def validate
    if associate_id == user_id
      errors.add_to_base("You cannot add yourself as a contact.")
    end
  end
  
end
