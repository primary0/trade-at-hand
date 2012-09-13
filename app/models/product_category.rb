class ProductCategory < ActiveRecord::Base
  has_many :products, :dependent => :destroy
  has_many :listings, :through => :products
  validates_presence_of :name, :description
  validates_uniqueness_of :name
  
  default_scope :order => 'name ASC'
  
  # Instance methods overridden with business logic
  def before_destroy
    if self.products.empty? 
      true
    else
      errors.add_to_base("A product category with products defined in the category cannot be removed.") 
      false
    end
  end
    
end