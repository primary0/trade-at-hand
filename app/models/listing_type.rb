class ListingType < ActiveRecord::Base
  has_many :listings, :dependent => :destroy
  validates_uniqueness_of :name
  validates_presence_of :name, :description
  
  # Instance methods overridden with business logic
  def before_destroy
    if self.listings.empty? 
      true
    else
      errors.add_to_base("A listing type which has listings defined for the type cannot be deleted.") 
      false
    end
  end
  
  # Statistics methods
  #-------------------
  
  # Array of of arrays containing the following data
  # First array contains the raw number of litings.count per type
  # Second array countains the listing.count as a percentage of listing.all.count
  # Third array contains the listing type names... for labeling and stuff.
  
  def self.stats_total
    a = []
    b = []
    c = []
    total = Listing.count.to_f    
    self.all.each do |n|
      a << [n.name, n.listings.count]
      perc = (n.listings.count.to_f/total) * 100
      b << perc
      c << n.name
    end
    return [a,b,c]
  end
     
end
