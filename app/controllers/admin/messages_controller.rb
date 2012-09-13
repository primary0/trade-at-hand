class Admin::MessagesController < ApplicationController
  layout 'admin'
  resource_this :path_prefix => "admin_", :will_paginate => true

  before_filter :is_admin  
  after_filter :set_destroyed_flash, :only => [:destroy]
  
  protected
  
  def load_messages
    @messages = Message.all.paginate :page => params[:page], :per_page => 25
  end
  
  def set_destroyed_flash
    flash[:notice] = 'Message was deleted.'
    flash[:type] = 'information'
  end

end
