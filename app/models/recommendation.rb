class Recommendation < ActiveRecord::Base
  
  validates_uniqueness_of :user_id, :scope => :author_id, :message => "You have already recommended this user."
    
  belongs_to :receiver, :class_name => "User", :foreign_key => "user_id"
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"

end
