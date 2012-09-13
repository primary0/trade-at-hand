class Admin::ContactsController < ApplicationController
  layout 'admin'
  resource_this :path_prefix => "admin_", :will_paginate => true

  before_filter :is_admin
  
  private
  
  def load_contacts
    @user = User.find(params[:user_id])
    @contacts = @user.contacts.find(:all).paginate :page => params[:page_c], :per_page => 25
    @inverse_contacts = @user.inverse_contacts.find(:all).paginate :page => params[:page_i], :per_page => 25
  end
  
  def destroy_contact
    @user = User.find(params[:user_id])
    @contact = Contact.find(params[:id])
    @associate = @contact.associate
    @contact = @contact.destroy
    if params[:from_associate] == true
      redirect_to admin_user_contacts_path(@associate)
    else
      redirect_to admin_user_contacts_path(@user)
    end
  end
  
end
