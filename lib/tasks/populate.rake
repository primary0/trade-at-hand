namespace :db do
  task :populate => :environment do
    
    require 'populator'
    require 'faker'
        
    [Product, Listing].each(&:delete_all)
    
    User.populate 100 do |user|
      user.full_name = Faker::Name.name
      user.phone = Faker::PhoneNumber.phone_number
      user.email = Faker::Internet.email      
      user.address = Faker::Address.street_address
      user.street = Populator.words(2).titleize
      user.island_id = [1,2,3,4,5,6,7,8,9,10]
      user.active = true
      user.crypted_password = "9ER498HFP98ERJWEP98FJP9W8EJP9W8EJFP98JEPW98FJPW9E8VJPW98ET"
      user.password_salt = "SALT"
      user.perishable_token = "PTOKEN"
      user.persistence_token = "PTOKEN"
      user.single_access_token = "STOKEN"
      user.login_count = "1"
      user.failed_login_count = "0"
      user.admin = false
    end
    
    Product.populate 30..50 do |product|
      product.product_category_id = 1+rand(3)
      product.name = Populator.words(1..2).titleize
      product.description = Populator.sentences(2..3)
      Listing.populate 25..50 do |listing|
        listing.listing_type_id = 1+rand(2)
        listing.product_id = product.id
        listing.user_id = 1+rand(100)
        listing.measuring_system_id = 1+rand(3)
        listing.created_at = 6.months.ago..Time.now
        listing.description = Populator.sentences(2..3)
        listing.quantity = [10, 100, 500, 50]
        listing.price = [10.50, 150.00, 200.00, 60.00]
        listing.expiry_date = listing.created_at + 7.days
        listing.sold = false
      end
    end
    
  end
end