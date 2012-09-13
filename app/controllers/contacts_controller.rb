class ContactsController < ApplicationController
  before_filter :require_user
  
  def index
    redirect_to root_url
  end
  
  def destroy
    @contact = Contact.find(params[:id])
    if @contact.user != current_user
      redirect_to root_url
    else    
      @contact.destroy
      flash[:notice] = "Contact was removed."    
      redirect_to user_path(current_user)
    end
  end
  
  def create
    @contact = current_user.contacts.build(:associate_id => params[:associate_id])
    if @contact.save
      flash[:notice] = "Contact was added successfully."
      redirect_to user_path(@contact.associate)  
    else
      flash[:notice] = "Contact already exists."      
      redirect_to user_path(params[:associate_id])
    end
  end
        
end
