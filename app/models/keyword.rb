class Keyword < ActiveRecord::Base
  belongs_to :product
  validates_uniqueness_of :name
  validates_presence_of :name
  attr_accessor :should_destroy
  
  def should_destroy?
    should_destroy.to_i == 1
  end
  
  def before_save
    self.name = self.name.downcase.titleize
  end
end
