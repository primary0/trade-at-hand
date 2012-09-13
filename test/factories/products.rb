require 'factory_girl'

Factory.define :product_category do |f|
  f.sequence(:name) {|n| "Product category #{n}"}
  f.description "Description"
end

Factory.define :measuring_system do |f|
  f.sequence(:name) {|n| "Measuring system #{n}"}
  f.description "Description"  
end

Factory.define :product do |f|
  f.sequence(:name) {|n| "Product #{n}"}
  f.description "Description"    
  f.association :product_category
end