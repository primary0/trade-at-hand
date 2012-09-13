class Message < ActiveRecord::Base
    
  validates_presence_of :message, :msisdn
  
  attr_accessor :commands, :command, :response, :user
  default_scope :order => 'created_at DESC'
    
  # CONSTANTS
  LISTING_TYPE_ID_SELL = "1"
  LISTING_TYPE_ID_BUY = "2"
  DUPLICATE_SMS_INTERVAL = 60 # seconds
  
  # Instance methods
  
  def before_save
    
    # self.sms_command is assigned after initial save and during processesing.
    # processing takes place after saving
    # during processing, this validation should be bypassed
    # or this message itself will be found as a dupliate
    unless self.sms_command            
      @duplicates = Message.find(:all, :conditions => ["msisdn = :msisdn AND message = :message AND created_at > :created_at", {:msisdn => self.msisdn, :message => self.message, :created_at => DUPLICATE_SMS_INTERVAL.seconds.ago}])       
      if @duplicates.empty?
        true
      else
        self.errors.add(:is_valid, "Duplicate SMS detected. You sent the same message less than 1 minute ago.")
        false
      end
    end        
  end  
  
  def user
    User.find_by_phone(self.msisdn)
  end
  
  # SMS COMMAND EXECUTION
  #######################
  
  # Execute the registration command based on response
  def execute_register_user
    if self.user
      @response = "You have already registered as #{self.user.full_name}, #{self.user.location}."
    else
      @user = User.new(:full_name => @response["name"], :phone => self.msisdn, :island_id => @response["island_id"], :active => true)
      
      @user.reset_perishable_token
      @password = "#{@user.perishable_token}#{@user.perishable_token}"[1..7]
      @user.password = @password
      @user.password_confirmation = @password
      
      @saved = @user.save
      if @saved
        @response = "Registration successful for #{@user.full_name}, #{@user.location}. Password is #{@password}"
      else
        @response = "Registration failed."
      end
    end    
  end
  
  # Execute the sell command based on response
  def execute_sell
    
    # Product ID validity would have been verified during the execution of the method process_sell
    # product should not be nil    
    if self.user && self.user.active
      @listing = Listing.new(:product_id => @response["product_id"], :user_id => self.user.id, :quantity => @response["quantity"], :price => @response["price"], :listing_type_id => LISTING_TYPE_ID_SELL)
      @saved = @listing.save
      if @saved
        @response = "Listed for sale #{@listing.quantity} #{@listing.product.name.pluralize} @ #{@listing.rate}. Listing ID #{@listing.id}."
      else
        @response = "Sell listing failed."
      end
    else
      @response = "Your have not registered or your account has not yet been activated."
    end    
  end
  
  # Execute the buy command based on response
  def execute_buy
    
    # Product ID validity would have been verified during the execution of the method process_buy
    # product should not be nil  
    if self.user && self.user.active
      @listing = Listing.new(:product_id => @response["product_id"], :user_id => self.user.id, :quantity => @response["quantity"], :listing_type_id => LISTING_TYPE_ID_BUY )
      @saved = @listing.save
      if @saved
        @response = "Listed #{@listing.quantity} #{@listing.product.name.pluralize} for buying. Listing ID #{@listing.id}."
      else
        @response = "Buy listing failed."
      end
    else
      @response = "Your have not registered or your account has not yet been activated."
    end
  end
  
  # Execute the find command based on response
  def execute_find
    
    # Product ID validity would have been verified during the execution of the method process_find
    # product should not be nil
    @product = Product.find(@response["product_id"])
    @response = "#{@product.name.titleize.singularize} exists in our database as a valid product you can sell or request to buy."
  end
  
  # Execute search
  def execute_search
    
    # Product ID validity would have been verified during the execution of the method process_search
    # product should not be nil
    @product = Product.find(@response["product_id"])
    @listing = @product.listings.sell.active.first
    if @listing
      @response = "#{@listing.quantity} #{@listing.product.name.pluralize.downcase} available for #{@listing.rate} in #{@listing.location}. Contact #{@listing.user.full_name} on #{@listing.user.phone}."
    else
      @response = "No sell offers available for #{@product.name.pluralize.downcase} at the moment."
    end
  end
  
  # Execute the delete command
  def execute_delete
    @listing = Listing.active.find_by_id(@response["listing_id"])
    if @listing && self.user
      if @listing.user == self.user
        @listing.destroy
        @response = "Listing of #{@listing.brief_description} has now been deleted."
      else
        @response = "The listing number you entered is not valid."
      end
    else
      @response = "The listing number you entered is not valid."      
    end
  end
  
  # Execute update command
  def execute_update
    
    if @response["quantity"]
      @listing = Listing.active.find_by_id(@response["listing_id"])
    elsif @response["price"]
      @listing = Listing.active.sell.find_by_id(@response["listing_id"])
    end
        
    if @listing && self.user
      if @listing.user == self.user
        if @response["quantity"]
          @temp = @response["quantity"]
          @response = "Listing of #{@listing.brief_description} quantity has been changed to #{@temp}."          
          @listing.quantity = @temp
          @listing.save          
        elsif @response["price"]
          @temp = @response["price"]          
          @response = "Listing of #{@listing.brief_description} price has been changed to #{@temp}."          
          @listing.price = @temp
          @listing.save
        end
      else
        @response = "The listing number you entered is not valid."
      end
    else
      @response = "The listing number you entered is not valid."      
    end
  end
  
  # Execute sold command
  def execute_sold
    @listing = Listing.active.sell.find_by_id(@response["listing_id"])
    if @listing && self.user
      if @listing.user == self.user
        @listing.sold = true
        @listing.save
        @response = "Listing of #{@listing.brief_description} has been marked as sold."
      else
        @response = "The listing number you entered is not valid."
      end
    else
      @response = "The listing number you entered is not valid."      
    end
  end
  
  def execute_info
    @listing = Listing.active.find_by_id(@response["listing_id"])
    if @listing
      @response = "#{@listing.brief_description} listed by #{@listing.user.full_name}, #{@listing.user.location}. Phone: #{@listing.user.phone}."
    else
      @response = "The listing number you entered is not valid or it has been deleted or marked as sold out."      
    end
  end  
  
  # Execute activation
  def execute_activate
    if self.user
      if !self.user.active && self.user.perishable_token == @response["code"]
        self.user.activate!
        @response = "Your account has been activated."
      elsif self.user.active
        @response = "Your account is already active."
      else
        @response = "Account activation failed."
      end
    else
      @response = "Your have not registered yet."
    end
  end
  
  # Execute recommend
  def execute_recommend
    if self.user
      @recommended_user = User.find_by_phone(@response["phone_number"])
      if @recommended_user
        @recommendation = Recommendation.new
        @recommendation.receiver = @recommended_user
        @recommendation.author = self.user
        @saved = @recommendation.save
        if @saved
          @response = "You have recommended #{@recommended_user.full_name} to other users."
        else
          @response = "User was previously recommended by you."        
        end
      else
        @response = "The phone number you have entered is not a registered number."
      end
    else
      @response = "Your have not registered yet."
    end
  end
  
  # Password reset command
  def execute_password
    if self.user
                  
      @user = User.find(self.user.id)
      
      @user.reset_perishable_token!
      @response["password"] = "#{@user.perishable_token}#{@user.perishable_token}"[1..7]
      
      @user.password = @response["password"]
      @user.password_confirmation = @response["password"]
      @saved = @user.save
      
      if @saved
        @response = "Your password has been reset and the new password is #{@response["password"]}"
      else
        @response = "Your password could not be reset."
      end
      
    else
      @response = "Your have not registered yet."      
    end
  end
  
  # SMS MESSAGE PARSING
  ######################
  
  # The switchboard
  def process
    
    # Set variables first
    @commands = ["reg", "buy", "sell", "find", "del", "search", "update", "sold", "activate", "recommend", "password", "help", "info"]
    @response = {}
    @message = message

    # Setup words array
    @words = @message.split(" ")
    @words.each do |word|
      word.strip!
    end    
    
    # Check for commands
    @command = self.check_commands
    
    if @command
      self.sms_command = @command
      self.save!      
    end    
    
    # Begin switch if command is found
    # Registration
    if @command == "reg"
      unless self.process_registration_information
        @response = 'Registration failed. For help send "help reg".'
      else
        self.execute_register_user
        self.is_valid = true
      end
      
    # Sell command
    elsif @command == "sell"
      unless self.process_sell
        @response = 'Sell listing failed. For help send "help sell".'
      else
        self.execute_sell
        self.is_valid = true
      end
      
    # Buy command
    elsif @command == "buy"
      unless self.process_buy
        @response = 'Buy listing failed. For help send "help buy".'
      else
        self.execute_buy
        self.is_valid = true
      end
      
    # Find command  
    elsif @command == "find"
      unless self.process_find
        @response = "Product not found."
      else
        self.execute_find
        self.is_valid = true
      end
      
    # Delete command  
    elsif @command == "del"
      unless self.process_delete
        @response = 'Listing deletion failed. For help send "help del".'
      else
        self.execute_delete
        self.is_valid = true        
      end
    
    # Search command  
    elsif @command == "search"
      unless self.process_search
        @response = "Product not found."
      else
        self.execute_search
        self.is_valid = true        
      end
    
    # Update command
    elsif @command == "update"
      unless self.process_update
        @response = 'Listing updating failed. For help send "help update".'
      else
        self.execute_update
        self.is_valid = true        
      end
      
    # Sold command
    elsif @command == "sold"
      unless self.process_sold
        @response = 'Failed to mark listing as sold. For help send "help sold".'
      else
        self.execute_sold
        self.is_valid = true
      end
    
    # Activate command  
    elsif @command == "activate"
      unless self.process_activate
        @response = "You have not yet registed or your activation code is not valid."
      else
        self.execute_activate
        self.is_valid = true
      end
      
    elsif @command == "password"
      unless self.process_password
        @response = 'Could not reset password. For help send "help password".'
      else
        self.execute_password
        self.is_valid = true
      end
    
    # Recommend command
    elsif @command == "recommend"
      unless self.process_recommend
        @response = 'Please enter a valid phone number. For help send "help recommend".'
      else
        self.execute_recommend
        self.is_valid = true
      end

    # Info command
    elsif @command ==  "info"
      unless self.process_info
        @response = "Please enter a valid listing ID."
      else
        self.execute_info
        self.is_valid = true
      end

    # Help command
    elsif @command == "help"
      self.process_help
      self.is_valid = true
                              
    #Failover        
    else  
      @response = false
      return false
    end
    
    # Let's return something for the process method
    if @response == false
      return false
    else
      self.save!     
      return true
    end
        
  end # End process (switchboard)
  
  # Initial Parsing
  def check_commands
    
    # Loop through commands
    # look for a match in the first word
    @commands.each do |c|
      if @words.first.match(/^#{c}$/i)
        @words.delete(@words.first)
        return c
      end
    end
    
    # Default returns false
    return false    
  end # End check_commands
  
  # Pre execution processing
  
  def process_password
    if @words.first && @words.length == 1 && @words.first.match(/reset/i)
      @response["password"] = true
      # Nothing to assign to hash actually
      return true
    end
    # Default returns false
    return false      
  end
  
  def process_help
    
    if @words.length == 1
      x = @words.first
      
      # reg
      if x.match(/reg/i)
        @response = 'To register send "reg [full name] [atoll] [island]". Example: "reg ahmed mohamed gn huvahmulah".'
        
      # find
      elsif x.match(/search/i)
        @response = 'To find latest sell listing for a product send "search [product name]". Example: "search kaashi".'
      
      # search      
      elsif x.match(/find/i)
        @response = 'To confirm if a particular product name exists in our system send "find [product name]". Example: "find kaashi".'
        
      elsif x.match(/sell/i)
        @response = 'To list products for sale send "sell [product name] [quantity] [unit price]". Example: "sell kaashi 100 5" to sell 100 coconuts at MVR 5.00 each.'
        
      elsif x.match(/buy/i)
        @response = 'To create a buying request for a product send "buy [product name] [quantity]". Example: "buy kaashi 500" to make a request to buy 500 coconuts.'
        
      elsif x.match(/password/i)
        @response = 'To reset your website access password send "password reset". A new password will be generated and sent to you.'
        
      elsif x.match(/update/i)
        @response = 'To update price or quantity of a listing you created send "update [listing ID] [quantity or price] [amount]". Example: "update 5934 quantity 200" to change the quantity of listing id 5934 to 200.'
        
      elsif x.match(/sold/i)
        @response = 'To set a selling item of yours as sold out send "sold [listing ID]". Example: "sold 5934" to mark the listing with ID 5932 as sold out.'
        
      elsif x.match(/del/i)
        @response = 'To delete a listing you created send "del [listing ID]". Example "del 5934" to delete the listing with ID 5934.'
        
      elsif x.match(/recommend/i)
        @response = 'To mark another user as recommended by you send "recommend [phone number]". Example: "recommend 9696909" to recommend the user who has the phone number 9696909.'

      elsif x.match(/info/i)
        @response = 'To view details of a listing send "info [listing ID]". Example "info 5934" to view details of the listing with ID 5934.'
                
      else
        @response = 'Available commands are: reg, find, search, sell, buy, password reset, update, sold, del, recommend and help. For command help send "help [command]".'
      end      
    else
      @response = 'Available commands are: reg, find, search, sell, buy, password reset, update, sold, del, recommend and help. For command help send "help [command]".'
    end
    
    # For help, default returns true
    return true
  end
  
  def process_recommend
    
    if @words.first && @words.length == 1 && @words.first.match(/^\d{7}$/)
      @response["phone_number"] = @words.first
      # Phone number found
      return true
    end
    # Default returns false
    return false    
  end
  
  def process_activate
    if @words.first
      if @words.first.match(/^\d+$/)
        @response["code"] = @words.first
        # Activation code and user found
        return true
      end
    end    
    # Default returns false
    return false
  end  
  
  def process_update
    
    # Get listing ID
    if @words.first && @words.first.match(/^\d+$/)
      @response["listing_id"] = @words.first
      @words.delete_at(0)
    end
    
    # Get update attribute. Quantity, price or status
    if @response["listing_id"]
      if @words.first && (@words.first == "quantity") || (@words.first == "price")
        @response["attribute"] = @words.first
        @words.delete_at(0)
      end
    end
    
    if @response["attribute"]      
      if @response["attribute"] == "quantity"
        if @words.first && @words.first.match(/^\d+$/)
          @response["quantity"] = @words.first
          # Attribute found. Return true
          return true          
        end
      elsif @response["attribute"] == "price"
        if @words.first && @words.first.match(/^\d+(\.\d{1,2}){0,1}$/)
          @response["price"] = @words.first
          # Attribute found. Return true
          return true          
        end
      end
    end
    
    # Default returns false
    return false      
  end
  
  def process_search
    
    # Get product
    product_word = @words.join(" ")
    @product = Product.name_equals(product_word.titleize.singularize).first
    if @product.nil?
      @keyword = Keyword.find_by_name(product_word.downcase.titleize)
      if @keyword
        @product = @keyword.product
      end
    end
    if @product
      @response["product_id"] = @product.id
      # Product found. Return true
      return true  
    end
    
    # Default returns false
    return false    
  end
  
  def process_delete
    
    # Get listing ID
    if @words.first && @words.last.match(/^\d+$/)
      @response["listing_id"] = @words.last
      # Listing ID found. Return true
      return true
    end
    
    # Default returns false
    return false        
  end
  
  def process_find
    
    # Get product
    product_word = @words.join(" ")
    @product = Product.name_equals(product_word.titleize.singularize).first
    if @product.nil?
      @keyword = Keyword.find_by_name(product_word.downcase.titleize)
      if @keyword
        @product = @keyword.product
      end
    end    
    if @product
      @response["product_id"] = @product.id
      # Product found. Return true
      return true  
    end
    
    # Default returns false
    return false    
  end
  
  def process_sell
    
    # Get price
    if @words.last && @words.last.match(/^\d+(\.\d{1,2}){0,1}$/)
      @response["price"] = @words.last
      @words.delete_at(@words.length - 1)        
    end
    
    # Get quantity
    unless @response["price"].nil? || @words.empty?
      if @words.last && @words.last.match(/^\d+$/)
        @response["quantity"] = @words.last
        @words.delete_at(@words.length - 1)
      end
    end
    
    # Get product
    unless @response["quantity"].nil? || @words.empty?      
      product_word = @words.join(" ")
      @product = Product.name_equals(product_word.titleize.singularize).first
      if @product.nil?
        @keyword = Keyword.find_by_name(product_word.downcase.titleize)
        if @keyword
          @product = @keyword.product
        end
      end      
      if @product
        @response["product_id"] = @product.id
        # Product, quantity and price correct. Return true        
        return true
      end
    end
    
    # Default returns false
    return false
  end # End process_sell
  
  def process_buy
    
    # Get quantity
    if @words.last && @words.last.match(/\d+/)
      @response["quantity"] = @words.last
      @words.delete_at(@words.length - 1)
    end

    
    # Get product
    unless @response["quantity"].nil? || @words.empty?
      product_word = @words.join(" ")
      @product = Product.name_equals(product_word.titleize.singularize).first
      if @product.nil?
        @keyword = Keyword.find_by_name(product_word.downcase.titleize)
        if @keyword
          @product = @keyword.product
        end
      end      
      if @product
        @response["product_id"] = @product.id
        # Product and quantity correct. Return true        
        return true
      end
    end
    
    # Default returns false
    return false    
  end # End process_buy
  
  def process_registration_information
    
    # Get atoll
    unless @words.empty?
      atoll_word = @words[@words.length - 2]
      Atoll.all.each do |atoll|
        if atoll_word.downcase == atoll.abbreviation.downcase
          @response["atoll_id"] = atoll.id          
          @words.delete(atoll_word)  
        end
      end
    end
    
    # Get island
    unless @response["atoll_id"].nil? || @words.empty?
      island_word = @words[@words.length - 1]      
      island = Island.name_like(island_word.downcase.titleize).atoll_id_equals(@response["atoll_id"]).first
      unless island.nil?
        @response["island_id"] = island.id
        @words.delete(island_word)
      end
     end
    
    # Get name
    unless @response["island_id"].nil? || @words.empty?
      unless @words.empty?
        @response["name"] = @words.join(" ")
        @response["name"] = @response["name"].titleize        
        # Atoll, island and name correct. Return true        
        return true
      end
    end
    
    # Default returns false
    return false    
  end # End process_registration_information
  
  def process_sold
    
    # Get listing ID
    if @words.last && @words.length == 1 && @words.last.match(/^\d+$/)
      @response["listing_id"] = @words.last
      # Attribute found. Return true
      return true      
    end
    
    # Default returns false
    return false    
  end
  
  def process_info
    
    # Get listing ID
    if @words.last && @words.length == 1 && @words.last.match(/^\d+$/)
      @response["listing_id"] = @words.last
      # Attribute found. Return true
      return true      
    end
    
    # Default returns false
    return false    
  end

end
