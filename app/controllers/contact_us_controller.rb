class ContactUsController < ApplicationController
  
  def index
    render
  end
  
  def create
    Notifier.deliver_contact_us(params[:email], params[:name], params[:phone], params[:message])
    return if request.xhr?
    flash[:notice] = "Your message was sent successfully."
    redirect_to root_url
  end
  
end
