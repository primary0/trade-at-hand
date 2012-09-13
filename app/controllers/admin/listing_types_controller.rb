class Admin::ListingTypesController < ApplicationController
  layout 'admin'
  resource_this :path_prefix => "admin_", :will_paginate => true
  
  before_filter :is_admin  
  after_filter :set_flash_type_information, :only => [:create, :update]
  
  protected
  
  def destroy_listing_type
    if @listing_type.destroy
      flash[:notice] = 'Listing type was deleted.'
      flash[:type] = 'information'
      redirect_to admin_listing_types_path
    else
      flash[:notice] = @listing_type.errors.each_full{|error| puts error }
      flash[:type] = 'error'
      redirect_to admin_listing_types_path(@listing_type)
    end
  end
  
  def set_flash_type_information
    flash[:notice] = 'Listing type was successfully updated.'
    flash[:type] = 'information'
  end
end
