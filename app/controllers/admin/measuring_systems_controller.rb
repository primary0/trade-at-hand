class Admin::MeasuringSystemsController < ApplicationController
  layout 'admin'
  resource_this :path_prefix => "admin_", :will_paginate => true
  
  before_filter :is_admin
  after_filter :set_flash_type_information, :only => [:create, :update]
  
  protected
  
  def destroy_measuring_system
    if @measuring_system.destroy
      flash[:notice] = 'Measurin system was deleted.'
      flash[:type] = 'information'
      redirect_to admin_measuring_systems_path
    else
      flash[:notice] = @measuring_system.errors.each_full{|error| puts error }
      flash[:type] = 'error'
      redirect_to admin_measuring_system_path(@measuring_system)
    end
  end
  
  def set_destroyed_flash
    flash[:notice] = 'Measuring system was deleted.'
    flash[:type] = 'information'
  end
  
  def set_flash_type_information
    flash[:notice] = 'Measuring system was successfully updated.'
    flash[:type] = 'information'
  end
  
end
