class HomeController < ApplicationController
  
  def index
    # Set Island or Atoll
    @island = ""
    @atoll = ""
    @islands = []
    if params[:atoll]
      @atoll = Atoll.find(params[:atoll])
      @islands = @atoll.islands.inhabited.all
    elsif params[:island]
      @island = Island.find(params[:island])
      @atoll = @island.atoll
      @islands = @atoll.islands
    end
        
    @product_categories = ProductCategory.all(:include => [:products])
    if params[:atoll]
      @atoll = Atoll.find(params[:atoll])
      @islands = @atoll.islands.inhabited.all
    else
      @islands = []
    end
  end
  
  def index2
    # Set Island or Atoll
    @island = ""
    @atoll = ""
    @islands = []
    if params[:atoll]
      @atoll = Atoll.find(params[:atoll])
      @islands = @atoll.islands.inhabited.all
    elsif params[:island]
      @island = Island.find(params[:island])
      @atoll = @island.atoll
      @islands = @atoll.islands
    end
        
    @product_categories = ProductCategory.all(:include => [:products])
    if params[:atoll]
      @atoll = Atoll.find(params[:atoll])
      @islands = @atoll.islands.inhabited.all
    else
      @islands = []
    end    
  end
  
end
