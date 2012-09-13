require 'factory_girl'

Factory.define :listing_type do |f|
  f.sequence(:name) {|n| "Listing type #{n}"}
  f.description "Description"  
end

Factory.define :listing do |f|
  f.association :listing_type
  f.association :user
  f.association :product
  f.price "100"
  f.quantity "10"
end

Factory.define :setting do |f|
  f.sequence(:name) {|n| "Setting #{n}"}
  f.value "value"
  f.description "Description"
end