require 'factory_girl'

Factory.define :user do |f|
  f.sequence(:phone) {|n| "777#{n}"}
  f.sequence(:email) {|n| "example_#{n}@example.com"}
  f.sequence(:nickname) {|n| "user_#{n}"}    
  f.full_name "Foo Bar"
  f.address "Address"
  f.street "Street"
  f.island "Island"
  f.atoll "Atoll"
  f.password "password"
  f.password_confirmation {|n|n.password}
end

Factory.define :active_user, :parent => :user do |f|
  f.active true
end

Factory.define :inactive_user, :parent => :user do |f|
  f.active false
end

Factory.define :invalid_user, :parent => :user do |f|
  f.active false
  f.phone nil
end

Factory.define :admin, :parent => :user do |f|
  f.active true
  f.admin true
end

Factory.define :associate, :parent => :user do |f|
  f.email "associate@example.com"
  f.phone "11111"
  f.active true
end