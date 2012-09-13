class SearchController < ApplicationController
  
  def index
    
    if params[:query]
      @words = params[:query].split(" ")
    end
    
    @products = []
    @keywords = []
    @users = []
    @islands = []
    @atolls = []
    
    @words.each do |word|
      @products << Product.name_like(word).all
      @keywords << Keyword.name_like(word).all
      @users << User.full_name_like(word).all
      @islands << Island.name_like(word).all
      @atolls << Atoll.name_or_abbreviation_like(word).all      
    end
    
    @products.flatten!
    @keywords.flatten!
    @users.flatten!
    @islands.flatten!
    @atolls.flatten!

    @temp = []
    @listings = []
    
    if !@atolls.empty?
      @temp = @atolls.collect{|x| x.islands.collect {|a| a.users.collect{|i| i.listings.active.all}}}.flatten
      if !@listings.empty? && !@temp.empty?
        @listings = @listings & @temp
      else
        @listings = @temp
      end
    end      
    
    if !@islands.empty?
      @temp = @islands.collect{|x| x.users.collect{|i| i.listings.active.all}}.flatten
      if !@listings.empty? && !@temp.empty?
        @listings = @listings & @temp
      else
        @listings = @temp
      end
    end
          
    if !@users.empty?
      @temp = @users.collect{|x| x.listings.active.all}.flatten    
      if !@listings.empty? && !@temp.empty?
        @listings = @listings & @temp
      else
        @listings = @temp
      end  
    end
    
    if !@keywords.empty?
      @temp = @keywords.collect{|x| x.product.listings.active.all}.flatten
      if !@listings.empty? && !@temp.empty?
        @listings = @listings & @temp
      else
        @listings = @temp
      end
    end
    
    if !@products.empty?
      @temp = @products.collect{|x| x.listings.active.all}.flatten
      if !@listings.empty? && !@temp.empty?
        @listings = @listings & @temp
      else
        @listings = @temp
      end
    end
        
    if @listings
      @listings.flatten!
      @listings = @listings.paginate :page => params[:page], :per_page => 50      
    end
    
  end
  
end
