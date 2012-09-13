class Admin::PagesController < ApplicationController
  layout 'admin'
  resource_this :path_prefix => "admin_", :will_paginate => true

  before_filter :is_admin  
  after_filter :set_flash_type_information, :only => [:create, :update]
  after_filter :set_destroyed_flash, :only => [:destroy]
  
  protected
  
  def destroy
    redirect_to admin_pages_path
  end
  
  def load_page
    @page = Page.find_by_permalink(params[:id])
  end
  
  def set_destroyed_flash
    flash[:notice] = 'Pages cannot be deleted from the system.'
    flash[:type] = 'warning'
  end
  
  def set_flash_type_information
    flash[:notice] = 'Page was successfully updated.'
    flash[:type] = 'information'
  end
end
