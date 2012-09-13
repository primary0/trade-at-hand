class Listing < ActiveRecord::Base
  belongs_to :user
  belongs_to :product
  belongs_to :listing_type
  belongs_to :measuring_system
  
  validates_presence_of :user_id, :product_id, :listing_type_id, :quantity
  validates_presence_of :price, :if => :is_selling?
  validates_numericality_of :quantity, :message => "should be a number"
  validates_numericality_of :price, :allow_nil => true, :message => "should be a number"
  
  default_scope :order => 'listings.created_at DESC'
  
  named_scope :active, :conditions => ['expiry_date >= ? and sold = ?', Date.today, false], :include => [{:user => {:island => :atoll}}, :listing_type, :product, :measuring_system]
  named_scope :inactive, :conditions => ['expiry_date < ? OR sold = ?', Date.today, true]      
  
  named_scope :of_listing_type, lambda { |listing_type|
    {:conditions => ["listing_type_id = ? and expiry_date >= ? and sold != ?", listing_type, Date.today, true] }}    
  named_scope :of_active_listing_type, lambda { |listing_type|
    {:conditions => ["listing_type_id = ? and expiry_date >= ?", listing_type, Date.today] }}    
  named_scope :of_inactive_listing_type, lambda { |listing_type|
    {:conditions => ["listing_type_id = ? and expiry_date < ?", listing_type, Date.today] }}                      
  
  named_scope :sell, :conditions => {:listing_type_id => 1}
  named_scope :buy, :conditions => {:listing_type_id => 2}    
  named_scope :latest, :limit => 10
  
  delegate :location, :to => :user
  # delegate :product_category_id, :to => :product
  
  #attr_accessor :product_category_id
  
  #def product_category_id
  #  self.product.product_category_id
  #end
    
  def brief_description
    if self.listing_type_id == 1
      "#{self.quantity} #{self.product.name.downcase.pluralize} for sale at #{self.rate}"
    else
      "#{self.quantity} #{self.product.name.downcase.pluralize} requested for buying"
    end
  end
  
  def is_selling?
    listing_type_id == 1
  end
  
  def ends_in
    self.expiry_date.to_date - Date.today
  end
  
  def before_create
    if self.expiry_date == nil
      @default_expiry_duration = Setting.find_by_name("Listing duration")
      if @default_expiry_duration
        self.expiry_date = @default_expiry_duration.value.to_i.days.from_now
      else
        self.expiry_date = 14.days.from_now
      end
    end
  end
  
  def worth
    if price
      quantity * price
    else
      0
    end
  end
  
  def current_measuring_system
    measuring_system ? measuring_system.abbreviation : (
      product.measuring_systems.empty? ? "kilos" : product.measuring_systems.all.first.abbreviation)
  end
  
  def rate
    if price
      "MVR #{price} per #{current_measuring_system.singularize.downcase}"
    else
      "no price set"
    end
  end
  
  def real_quantity
    [quantity, current_measuring_system].join(" ")
  end
  
  def expired
    if self.expiry_date.to_date < Time.now.to_date
      "Expired"
    else
      "Not expired"
    end
  end
  
  def real_expiry    
    if self.expiry_date.to_date < Time.now.to_date
      "Expired"
    else
      "Listing ends in #{ends_in} days."
    end    
  end
  
  def rss_title
    "#{self.listing_type.name} - #{self.product.name.downcase.pluralize}"    
  end
  
  def rss_description
    "#{self.brief_description} listed by #{self.user.full_name}, #{self.user.location}. Phone: #{self.user.phone}."
  end
  
  # Statistics methods
  # ------------------
  
  # Returns an array containing 2 arrays
  # First array contains count of listings for a month
  # Second array contains the name of the month
  
  def self.stats_monthly
    all = self.all.group_by { |t| t.created_at.beginning_of_month }
    result = Hash.new
    i = Hash.new
    all.keys.sort.each do |month|
      i = {"#{month.to_date.to_formatted_s(:short)}" => all[month].length}
      result.merge!(i)
    end
    return result
  end

end