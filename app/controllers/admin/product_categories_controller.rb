class Admin::ProductCategoriesController < ApplicationController
  layout 'admin'
  resource_this :path_prefix => "admin_", :will_paginate => true
  
  before_filter :is_admin  
  after_filter :set_flash_type_information, :only => [:create, :update]
  
  protected
  
  def destroy_product_category
    if @product_category.destroy
      flash[:notice] = 'Product category was deleted.'
      flash[:type] = 'information'
      redirect_to admin_product_categories_path
    else
      flash[:notice] = @product_category.errors.each_full{|error| puts error }
      flash[:type] = 'error'
      redirect_to admin_product_category_path(@product_category)
    end
  end
  
  def set_flash_type_information
    flash[:notice] = 'Product category was successfully updated.'
    flash[:type] = 'information'
  end
  
end
