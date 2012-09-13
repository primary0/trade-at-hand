class AccountsController < ApplicationController
  
  # Activation
  # Activation form
  #def activation
  #  render
  #end
  
  # Activation method
  #def activate
  #  @user = User.find_by_phone_and_perishable_token(params[:phone], params[:activation_code])
  #  if @user && @user.activate!
  #   call_rake :deliver_activation_confirmation, :user_id => @user.id
  #    flash[:notice] = "Your account has been successfully activated and you are now logged in."
  #    UserSession.create(@user)        
  #   redirect_to root_url
  #  else
  #   flash[:notice] = "Activation failed. Please check your phone number or activation code."
  #    render "activation"      
  #  end
  #end

  # Password Resetting
  # Request UI
  # def forgot_password
  #  render
  # end
  
  # Sending instructions
  # def send_password_reset_instructions
  #  @user = User.find_by_phone(params[:phone])
  #  if @user && @user.active
  #    call_rake :deliver_password_reset_instructions, :user_id => @user.id
  #    flash[:notice] = "Instructions to reset your password will be emailed to you shortly. Please check your email."  
  #    redirect_to root_url
  #  else
  #    flash[:notice] = "The account does not exist or is not activated."
  #    render "forgot_password"
  #  end      
  # end
  
  # Reset UI
  # def reset_password_confirmation
  #  @user = User.find_by_phone_and_perishable_token(params[:user], params[:token])
  #  unless @user && @user.active
  #    flash[:notice] = "Your request could not be processed. Please try again."
  #    render "forgot_password"
  #  end
  # end
  
  # Resetting action
  # def reset_password
  #  @user = User.find_by_phone_and_perishable_token(params[:phone], params[:token])
  #  if @user && @user.active
  #    if @user.update_attributes(params[:user])
  #      flash[:notice] = "Password was reset. Please login with your new password."
  #      redirect_to new_user_session_path
  #    else
  #      render "reset_password_confirmation"
  #    end
  #  else
  #    flash[:notice] = "Your request could not be processed. Please try again."
  #    render "forgot_password"      
  #  end
  #end
end
