class Admin::UsersController < ApplicationController
  layout 'admin'
  resource_this :path_prefix => "admin_", :will_paginate => true

  before_filter :is_admin  
  before_filter :activation_check, :only => [:show]
  before_filter :load_inactive_users, :only => [:index]
  before_filter :load_listings, :only => [:show]
  
  public 

  def deactivate
    @user = User.find(params[:id])
    if @user && @user.deactivate!
      flash[:notice] = "The user was deactivated."
      flash[:type] = "information"      
      redirect_to admin_user_url(@user)
    else
      flash[:notice] = "The user could not be deactivated. #{@user.errors.each_full{|error| puts error}}"
      flash[:type] = "error"      
      redirect_to admin_user_url(@user)
    end    
  end
  
  def activate
    @user = User.find(params[:id])
    if @user && @user.activate!
      flash[:notice] = "The user was successfully activated."
      flash[:type] = "information"      
      redirect_to admin_user_url(@user)
    else
      flash[:notice] = "The user could not be activated. #{@user.errors.each_full{|error| puts error}}"
      flash[:type] = "error"      
      redirect_to admin_user_url(@user)
    end
  end
  
  protected
  
  def destroy_user
    if @user.destroy
      flash[:notice] = 'User was deleted.'
      flash[:type] = 'information'
      redirect_to admin_users_path
    else
      flash[:notice] = @user.errors.each_full{|error| puts error }
      flash[:type] = 'error'
      redirect_to admin_user_path(@user)
    end
  end  
  
  def load_listings
    @listings = @user.listings.active.all.paginate :page => params[:page_a], :per_page => 25
    @inactive_listings = @user.listings.inactive.all.paginate :page => params[:page_i], :per_page => 25
  end
  
  def load_users
    @users = User.active_users.paginate :page => params[:page], :per_page => 25
  end
  
  def load_inactive_users
    @inactive_users = User.inactive_users.paginate :page => params[:page], :per_page => 25
  end  
  
  def activation_check
    unless @user.active
      if flash[:notice].nil?
        flash.now[:notice] = "This user has no yet activated the account."
        flash.now[:type] = "attention"
      end
    end
  end 

end
