class ArticlesController < ApplicationController
  
  def links
    @article_category = ArticleCategory.find_by_name("Links")
    if params[:id]
      @article = Article.find_by_id(params[:id])
    else
      @article = Article.new
      @article.title = @article_category.name
      @article.description = @article_category.description
    end    
  end  
    
  def about_us
    @article_category = ArticleCategory.find_by_name("About Us")
    if params[:id]
      @article = Article.find_by_id(params[:id])
    else
      @article = Article.new
      @article.title = @article_category.name
      @article.description = @article_category.description
    end    
  end
  
  def help
    @article_category = ArticleCategory.find_by_name("Help")
    if params[:id]
      @article = Article.find_by_id(params[:id])
    else
      @article = Article.new
      @article.title = @article_category.name
      @article.description = @article_category.description
    end     
  end
  
  def contact_us
    @article_category = ArticleCategory.find_by_name("Contact Us")    
    if params[:id]
      @article = Article.find_by_id(params[:id])
    else
      @article = Article.new
      @article.title = @article_category.name
      @article.description = @article_category.description
    end    
  end
  
  def terms_and_conditions
    @article_category = ArticleCategory.find_by_name("Terms and Conditions")    
    if params[:id]
      @article = Article.find_by_id(params[:id])
    else
      @article = Article.new
      @article.title = @article_category.name
      @article.description = @article_category.description
    end  
  end
  
  def privacy_policy
    @article_category = ArticleCategory.find_by_name("Privacy Policy")    
    if params[:id]
      @article = Article.find_by_id(params[:id])
    else
      @article = Article.new
      @article.title = @article_category.name
      @article.description = @article_category.description
    end    
  end
  
  def weather_forecast
    @article_category = ArticleCategory.find_by_name("Weather Forecast")    
    if params[:id]
      @article = Article.find_by_id(params[:id])
    else
      @article = Article.new
      @article.title = @article_category.name
      @article.description = @article_category.description
    end    
  end
  
  def ferry_schedule
    @article_category = ArticleCategory.find_by_name("Ferry Schedule")    
    if params[:id]
      @article = Article.find_by_id(params[:id])
    else
      @article = Article.new
      @article.title = @article_category.name
      @article.description = @article_category.description
    end    
  end  
    
end
