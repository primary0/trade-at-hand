class Admin::ListingsController < ApplicationController
  layout 'admin'
  resource_this :path_prefix => "admin_", :will_paginate => true

  before_filter :is_admin  
  before_filter :load_listing_type, :only => [:index]
  after_filter :set_flash_type_information, :only => [:create, :update]
  after_filter :set_destroyed_flash, :only => [:destroy]
  
  protected
  
  def load_listing_type
    if params[:listing_type]
      @listing_type = ListingType.find(params[:listing_type])
    else
      redirect_to admin_listings_path(:listing_type => ListingType.find(:first))
    end
  end
  
  def load_listings
    @listings = Listing.active.of_listing_type(params[:listing_type]).all.paginate :page => params[:page], :per_page => 25
  end
  
  def set_destroyed_flash
    flash[:notice] = 'Listing was deleted.'
    flash[:type] = 'information'
  end
  
  def set_flash_type_information
    flash[:notice] = 'Listing was successfully updated.'
    flash[:type] = 'information'
  end
    
end
