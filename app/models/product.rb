class Product < ActiveRecord::Base
  belongs_to :product_category
  has_many :listings, :dependent => :destroy
  has_many :keywords, :dependent => :destroy
  has_and_belongs_to_many :measuring_systems
  validates_presence_of :name
  validates_uniqueness_of :name
  after_update :save_keywords
  
  default_scope :order => 'name ASC'
  named_scope :has_listings, :joins => :listings, :conditions => ["listings.expiry_date < ?", Date.today]

  
  # Virtual attribute for keywords. Used in admin/products/edit and new forms
  def keyword_attributes=(keyword_attributes)
    keyword_attributes.each do |attributes|
      if attributes[:id].blank?
        keywords.build(attributes)
      else
        keyword = keywords.detect {|k| k.id == attributes[:id].to_i}
        keyword.attributes = attributes
      end
    end
  end
  
  def save_keywords
    keywords.each do |k|
      if k.should_destroy?
        k.destroy
      else
        k.save(false)
      end
    end
  end
  
  def before_save
    self.name = self.name.downcase.titleize
  end
  
  # Instance methods overridden with business logic
  def before_destroy
    if self.listings.empty? 
      true
    else
      errors.add_to_base("A product which has listings of it cannot be removed.") 
      false
    end
  end
  
end
