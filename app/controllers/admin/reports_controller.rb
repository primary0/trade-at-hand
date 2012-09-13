class Admin::ReportsController < ApplicationController
  layout 'admin'
  before_filter :is_admin    
    
  def index
    render
  end
  
  def create
    @from_date =  Date.civil(params[:range][:"from_date(1i)"].to_i,params[:range][:"from_date(2i)"].to_i,params[:range][:"from_date(3i)"].to_i)  
    @to_date =  Date.civil(params[:range][:"to_date(1i)"].to_i,params[:range][:"to_date(2i)"].to_i,params[:range][:"to_date(3i)"].to_i)  
    @listings = Listing.search(params[:search]).created_at_greater_than(@from_date).created_at_less_than(@to_date)

    if params[:product_category_id]
      @listings = @listings.find(:all, :include => :product, :conditions => ["products.product_category_id = ?", params[:product_category_id]], :order => "listings.created_at")
    end
    
    #@listings = Listing.find(:all, :conditions => ["listing_type_id = ? AND product_id = ?", params[:listing_type_id], params[:product_id]])
    
    csv_string = FasterCSV.generate do |csv|
      csv << ["Listing Type", "Product Category", "Product Name", "User", "Atoll", "Island", "Created at", "Marked as Sold"]

      @listings.each do |record|
        csv << [record.listing_type.name,
                record.product.product_category.name,
                record.product.name,
                record.user.full_name,
                record.user.island.atoll.abbreviation,
                record.user.island.name,
                record.created_at,
                record.sold
                ]
      end
    end

    filename = "data.csv"
    send_data(csv_string,
      :type => 'text/csv; charset=utf-8; header=present',
      :filename => filename)    
  end

end
