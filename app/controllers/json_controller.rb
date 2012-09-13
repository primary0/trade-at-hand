class JsonController < ApplicationController
  layout false
  
  def get_products_for_product_category
    @products = Product.find_all_by_product_category_id(params[:id], :order => "name ASC")
    ActiveRecord::Base.include_root_in_json = false
    respond_to do |format|
      format.json {render :json => @products}
    end
  end
  
  def get_islands_for_atoll
    @islands = Island.inhabited.find_all_by_atoll_id(params[:id], :order => "name ASC")
    ActiveRecord::Base.include_root_in_json = false
    respond_to do |format|
      format.json {render :json => @islands}
    end
  end
    
end
