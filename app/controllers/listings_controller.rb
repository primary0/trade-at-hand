class ListingsController < ApplicationController
  before_filter :require_user, :except => [:index, :show, :sell, :buy, :all_xml, :all_buy, :all_sell]
  before_filter :content_owner, :only => [:edit, :update, :destroy]
  before_filter :get_product_categories, :only => [:buy, :sell]
  
  def all_xml
    @listings = Listing.active.all(:limit => 100)
    render :layout => false
  end
  
  def all_buy
    @listings = Listing.buy.active.all(:limit => 100)
    render :layout => false
  end
  
  def all_sell
    @listings = Listing.sell.active.all(:limit => 100)
    render :layout => false
  end    
  
  def send_listing
    @listing = Listing.find(params[:listing_id])
    @user = current_user
    Notifier.deliver_send_to_a_friend(params[:email], @user.email, @user.phone, @user.full_name, @listing.rss_description)    
    return if request.xhr?
      flash[:notice] = "Your message was sent successfully."
    redirect_to root_url
  end
  
  def get_product_categories
    @product_categories = ProductCategory.find(:all, :include => :products)
  end
  
  def buy
    # Set Island or Atoll
    @island = ""
    @atoll = ""
    @islands = []
    @order = "created_at"
    
    if params[:atoll]
      @atoll = Atoll.find(params[:atoll])
      @islands = @atoll.islands.inhabited.all
    elsif params[:island]
      @island = Island.find(params[:island])
      @atoll = @island.atoll
      @islands = @atoll.islands
    end
    
    # Sorting stuff    
    if params[:quantity_by]
      @order = "quantity #{params[:quantity_by]} "
    end
    
    if params[:product_by]
      @order = "products.name #{params[:product_by]} "
    end
    
    if params[:price_by]
      @order = "price #{params[:price_by]} "
    end
    
    if params[:location_by]
      @order = "users.island_id #{params[:location_by]} "
    end            
    
    if params[:date_by]
      @order = "created_at #{params[:date_by]}"
    end
    
    # Sorting Resets
    if params[:quantity_by] == "ASC"
      @quantity_by = "DESC"
    else
      @quantity_by = "ASC"
    end
        
    if params[:product_by] == "ASC"
      @product_by = "DESC"
    else
      @product_by = "ASC"
    end
    
    if params[:price_by] == "ASC"
      @price_by = "DESC"
    else
      @price_by = "ASC"
    end
    
    if params[:location_by] == "ASC"
      @location_by = "DESC"
    else
      @location_by = "ASC"
    end
    
    if params[:date_by] == "ASC"
      @date_by = "DESC"
    else
      @date_by = "ASC"
    end  
    
    # Load the listings    
    if params[:product]
      @product = Product.find(params[:product])
      @all_listings = @product.listings.buy.active.all
    elsif params[:product_category]
      @product_category = ProductCategory.find(params[:product_category])
      @all_listings = @product_category.listings.buy.active.all      
    else
      @all_listings = Listing.active.buy.all
    end
    
    if params[:atoll]
      @users = @atoll.islands.collect{|x|x.users.all}.flatten
      @buffer_listings = @users.collect{|x|x.listings.buy.active.all}
    elsif params[:island]
      @users = @island.users
      @buffer_listings = @users.collect{|x|x.listings.buy.active.all}      
    end
    
    if @buffer_listings
      @listings = @all_listings.flatten & @buffer_listings.flatten
    else
      @listings = @all_listings
    end
    
    @listings = @listings.paginate :page => params[:page], :per_page => 50
  
  end
  
  def sell  
    
    # Set Island, atoll and default sort params
    @island = ""
    @atoll = ""
    @islands = []
    @order = "created_at"
    
    if params[:atoll]
      @atoll = Atoll.find(params[:atoll])
      @islands = @atoll.islands.inhabited.all
    elsif params[:island]
      @island = Island.find(params[:island])
      @atoll = @island.atoll
      @islands = @atoll.islands
    end
    
    # Sorting stuff    
    if params[:quantity_by]
      @order = "quantity #{params[:quantity_by]} "
    end
    
    if params[:product_by]
      @order = "products.name #{params[:product_by]} "
    end
    
    if params[:price_by]
      @order = "price #{params[:price_by]} "
    end
    
    if params[:location_by]
      @order = "users.island_id #{params[:location_by]} "
    end            
    
    if params[:date_by]
      @order = "created_at #{params[:date_by]}"
    end
    
    # Sorting Resets
    if params[:quantity_by] == "ASC"
      @quantity_by = "DESC"
    else
      @quantity_by = "ASC"
    end
        
    if params[:product_by] == "ASC"
      @product_by = "DESC"
    else
      @product_by = "ASC"
    end
    
    if params[:price_by] == "ASC"
      @price_by = "DESC"
    else
      @price_by = "ASC"
    end
    
    if params[:location_by] == "ASC"
      @location_by = "DESC"
    else
      @location_by = "ASC"
    end
    
    if params[:date_by] == "ASC"
      @date_by = "DESC"
    else
      @date_by = "ASC"
    end                
    
    # Load the listings    
    if params[:product]
      @product = Product.find(params[:product])
      @all_listings = @product.listings.sell.active.all(:order => @order)
    elsif params[:product_category]
      @product_category = ProductCategory.find(params[:product_category])
      @all_listings = @product_category.listings.sell.active.all(:order => @order)   
    else
      @all_listings = Listing.active.sell.all(:order => @order)
    end
    
    if params[:atoll]
      @users = @atoll.islands.collect{|x|x.users.all}.flatten
      @buffer_listings = @users.collect{|x|x.listings.sell.active.all(:order => @order)}
    elsif params[:island]
      @users = @island.users
      @buffer_listings = @users.collect{|x|x.listings.sell.active.all(:order => @order)}      
    end
    
    if @buffer_listings
      @listings = @all_listings.flatten & @buffer_listings.flatten
    else
      @listings = @all_listings
    end
    
    @listings = @listings.paginate :page => params[:page], :per_page => 50
  end
  
  def content_owner
    @listing = Listing.find(params[:id])
    if @listing.user != current_user
      redirect_to listing_path(@listing)
    end
  end
  
  def new
    @listing = Listing.new
    @listing.user = current_user
  end
  
  def create
    @listing = Listing.new(params[:listing])
    @listing.user = current_user
    if @listing.save
      flash[:notice] = "Listing was successfully created."
      redirect_to @listing
    else
      render "new"
    end
  end
       
  def destroy
    @listing = Listing.find(params[:id])
    if @listing.user == current_user
      @listing = @listing.destroy
      redirect_to user_path(current_user)
    else
      redirect_to root_url
    end
  end
  
  def sold
    @listing = Listing.find(params[:id])
    if @listing.user == current_user
      @listing.sold = true
      @listing.save
      redirect_to user_path(current_user)
    else
      redirect_to root_url
    end
  end
  
  def edit
    @listing = Listing.find(params[:id])
  end
  
  def update
    @listing = Listing.find(params[:id])
    if @listing.user == current_user
      #params[:listing][:user_id] = current_user.id
      #@listing.user = current_user    
      if @listing.update_attributes(params[:listing])
        flash[:notice] = "Listing was updated succesfully."
        redirect_to @listing
      else
        render "edit", :id => @listing
      end      
    else
      redirect_to root_url
    end
  end
  
  def show
    @listing = Listing.find(params[:id], :include => [{:product => :measuring_systems}, :listing_type, {:user => :recommendations_received}])
  end
  
end
