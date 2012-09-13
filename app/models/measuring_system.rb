class MeasuringSystem < ActiveRecord::Base
  has_many :listings, :dependent => :destroy
  has_and_belongs_to_many :products
  validates_presence_of :name, :description
  validates_uniqueness_of :name
  
  default_scope :order => 'name ASC'
  
  # Instance methods overridden with business logic
  def before_destroy
    if self.products.empty? && self.listings.empty?
      true
    else
      errors.add_to_base("A measuring system with products or listings associated with it cannot be removed.") 
      false
    end
  end

end
