class Admin::ArticlesController < ApplicationController
  layout 'admin'
  resource_this :path_prefix => "admin_", :will_paginate => true

  before_filter :is_admin  
  after_filter :set_flash_type_information, :only => [:create, :update]    
    
  protected
  
  def load_article
    @article = Article.find(params[:id])
    @article_category = @article.article_category
  end
  
  def destroy_article
    @article_category = @article.article_category
    if @article.destroy
      flash[:notice] = 'Article was deleted.'
      flash[:type] = 'information'
      redirect_to admin_article_category_path(@article_category)
    else
      flash[:notice] = @article.errors.each_full{|error| puts error }
      flash[:type] = 'error'
      redirect_to admin_article_path(@article)
    end
  end
  
  def new_article
    @article_category = ArticleCategory.find(params[:article_category])
    @article = Article.new
    @article.article_category = @article_category
  end
  
  def set_flash_type_information
    flash[:notice] = 'Article was successfully updated.'
    flash[:type] = 'information'
  end

end