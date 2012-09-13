class UsersController < ApplicationController
  before_filter :require_user, :except => [:new, :create, :show, :welcome]
  
  def recommend        
    if params[:user_id]
      @user = User.find(params[:user_id])
      @recommendation = Recommendation.new
      @recommendation.receiver = @user
      @recommendation.author = current_user
      @saved = @recommendation.save
      if @saved
        flash[:notice] = "Successfully marked this user as recommended."
      else
        flash[:notice] = "User was previously recommended."        
      end
      redirect_to user_path(@user)      
    else
      redirect_to root_url
    end
  end
  
  def new
    @user = User.new
    @selected_id = 8
    @atolls = Atoll.all
    @islands = Island.inhabited.find_all_by_atoll_id("8")    
  end
  
  def create
    @user = User.new(params[:user])
    @user.web_registration = true
    if @user.save_without_session_maintenance
      call_rake :deliver_activation_instructions, :user_id => @user.id      
      flash[:notice] = "Your account has been successfully created. Please check your e-mail for your account activation instructions!"
      redirect_to :action => "welcome"
    else
      @selected_id = 8
      @atolls = Atoll.all
      @islands = Island.inhabited.find_all_by_atoll_id("8")      
      render :action => "new"
    end
  end
  
  def welcome
    render
  end
  
  def edit
    @user = current_user
    @island = @user.island
    @atolls = Atoll.all
    @islands = Island.inhabited.find_all_by_atoll_id(@island.atoll)
    @selected_id = @island.atoll_id    
  end

  def show
    @user = User.find(params[:id])
    unless @user.active
      redirect_to root_url
    end
  end
  
  def update
    @user = current_user    
    params[:user][:phone] = @user.phone
    @user.web_registration = true    
     
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile has been successfully updated."
      redirect_to user_path(@user)
    else
      @island = @user.island
      @atolls = Atoll.all
      @islands = Island.inhabited.find_all_by_atoll_id(@island.atoll)
      @selected_id = @island.atoll_id      
      render :action => "edit"
    end
  end

end
