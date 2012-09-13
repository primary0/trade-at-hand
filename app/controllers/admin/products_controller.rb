class Admin::ProductsController < ApplicationController
  layout 'admin'
  resource_this :path_prefix => "admin_", :will_paginate => true

  before_filter :is_admin  
  before_filter :load_measuring_systems, :only => [:new, :edit, :update]
  after_filter :set_flash_type_information, :only => [:create, :update]
  
  public
    
  def new          
    respond_to do |format|
      format.html
      format.xml
      format.js
    end
  end
  
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end      
    
  protected
  
  def new_product
    @product = Product.new
    3.times { @product.keywords.build }
  end
  
  def update_product
    returning true do
      params[:product][:measuring_system_ids] ||= []      
      @updated = @product.update_attributes(params[:product])
    end
  end
  
  def load_measuring_systems
    @measuring_systems = MeasuringSystem.find(:all)
  end
  
  def load_product
    @product = Product.find(params[:id])
    @product_category = @product.product_category
  end
  
  def destroy_product
    @product_category = @product.product_category
    if @product.destroy
      flash[:notice] = 'Product was deleted.'
      flash[:type] = 'information'
      redirect_to admin_product_category_path(@product_category)
    else
      flash[:notice] = @product.errors.each_full{|error| puts error }
      flash[:type] = 'error'
      redirect_to admin_product_path(@product)
    end
  end
  
  def new_product
    @product_category = ProductCategory.find(params[:product_category])
    @product = Product.new
    1.times { @product.keywords.build }
    @product.product_category = @product_category    
  end
  
  def set_flash_type_information
    flash[:notice] = 'Product was successfully updated.'
    flash[:type] = 'information'
  end
    
end
