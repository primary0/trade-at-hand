class Admin::HomeController < ApplicationController
  layout 'admin'
  before_filter :is_admin
  
  def index
    render
  end
  
end
