class Admin::ArticleCategoriesController < ApplicationController
  layout 'admin'
  resource_this :path_prefix => "admin_", :will_paginate => true
  
  before_filter :is_admin  
  after_filter :set_flash_type_information, :only => [:create, :update]
  
  protected
  
  def destroy_article_category
    if @article_category.destroy
      flash[:notice] = 'Article category was deleted.'
      flash[:type] = 'information'
      redirect_to admin_article_categories_path
    else
      flash[:notice] = @article_category.errors.each_full{|error| puts error }
      flash[:type] = 'error'
      redirect_to admin_article_category_path(@article_category)
    end
  end
  
  def set_flash_type_information
    flash[:notice] = 'Article category was successfully updated.'
    flash[:type] = 'information'
  end
end
