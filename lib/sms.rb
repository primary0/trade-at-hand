class Sms
  
  attr_accessor :message, :command, :response, :valid
    
  def initialize(message)
        
    # Set variables first
    @commands = ["reg", "buy", "sell", "find"]
    @response = {}
    @message = message
    @valid = false

    # Setup words array
    @words = @message.split(" ")
    
    # Initial process procedure!
    self.process
    
  end # End initialize
    
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
  
  # The switchboard
  def process
    
    # Check for commands
    @command = self.check_commands
    
    # Begin switch if command is found
    # Registration
    if @command == "reg"
      unless self.process_registration_information
        @response = false
      end
      
    # Sell command
    elsif @command == "sell"
      unless self.process_sell
        @response = false
      end
      
    # Buy command
    elsif @command == "buy"
      unless self.process_buy
        @response = false
      end
      
    # Find command  
    elsif @command == "find"
      unless self.process_find
        @response = false
      end      
        
    #Failover        
    else  
      @response = false
    end      
  end # End process (switchboard)
  
  def process_find
    
    # Get product
    product_word = @words.first
    Product.all.each do |product|
      if product.name.downcase == product_word.downcase
        @response["product_id"] = product.id
        @words.delete(product_word)
        # Product found. Return true
        return true        
      end
    end
    
    # Default returns false
    return false    
  end
  
  def process_sell
    
    # Get price
    if @words.last.match(/^\d+(\.{0,1}\d{1,2})$/)
      @response["price"] = @words.last
      @words.delete_at(@words.length - 1)        
    end
    
    # Get quantity
    unless @response["price"].nil? || @words.empty?
      if @words.last.match(/^\d+$/)
        @response["quantity"] = @words.last
        @words.delete_at(@words.length - 1)
      end
    end
    
    # Get product
    unless @response["quantity"].nil? || @words.empty?
      product_word = @words.join(" ")
      Product.all.each do |product|
        if product.name.downcase == product_word.downcase
          @response["product_id"] = product.id
          # Product, quantity and price correct. Return true
          return true
        end
      end
    end
    
    # Default returns false
    return false
  end # End process_sell
  
  def process_buy
    
    # Get quantity
    if @words.last.match(/\d+/)
      @response["quantity"] = @words.last
      @words.delete_at(@words.length - 1)
    end

    
    # Get product
    unless @response["quantity"].nil? || @words.empty?
      product_word = @words.join(" ")
      Product.all.each do |product|
        if product.name.downcase == product_word.downcase
          @response["product_id"] = product.id
          # Product and quantity correct. Return true        
          return true
        end
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
      island = Island.name_equals(island_word.downcase.titleize).atoll_id_equals(@response["atoll_id"]).first
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

end

