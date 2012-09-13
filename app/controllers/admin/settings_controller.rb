class Admin::SettingsController < ApplicationController
  layout 'admin'
  resource_this :path_prefix => "admin_", :will_paginate => true

  before_filter :is_admin    
  after_filter :set_flash_type_information, :only => [:create, :update]
  
  protected
  
  def set_flash_type_information
    flash[:notice] = 'Setting was successfully updated.'
    flash[:type] = 'information'
  end
    
end
