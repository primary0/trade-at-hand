task :deliver_password_reset_instructions => :environment do
  user = User.find(ENV["USER_ID"])
  user.deliver_password_reset_instructions!
end

task :deliver_activation_confirmation => :environment do
  user = User.find(ENV["USER_ID"])
  user.deliver_activation_confirmation!
end

task :deliver_activation_instructions => :environment do
  user = User.find(ENV["USER_ID"])
  user.deliver_activation_instructions!
end

task :contact_us => :environment do
  user.deliver_activation_instructions!
end