class Notifier < ActionMailer::Base


  def send_to_a_friend(recipient_email, sender_email, sender_phone, sender_name, message)
     @subject = "Listing Information Email"
     @recipients = recipient_email
     @from = 'mvleads <no-reply@mvleads.com>'
 	   @body["email"] = sender_email
 	   @body["name"] = sender_name
 	   @body["phone"] = sender_phone
  	 @body["message"] = message
     @headers = {}
  end
  
  def contact_us(sender, name, phone, message)
     @subject = "Contact Us Email"
     @recipients = '5323@trade.gov.mv'
     @from = 'mvleads <no-reply@mvleads.com>'
 	   @body["email"] = sender
 	   @body["name"] = name
 	   @body["phone"] = phone
  	 @body["message"] = message
     @headers = {}
  end
  
  def activation_instructions(user)
    subject       "Activation Instructions"
    from          "mvleads <do-not-reply@mvleads.com>"
    recipients    user.email
    sent_on       Time.now
    body          :activation_code => user.perishable_token
  end

  def activation_confirmation(user)
    subject       "Activation Complete"
    from          "mvleads <do-not-reply@mvleads.com>"
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end
  
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "mvleads <do-not-reply@mvleads.com>"
    recipients    user.email
    sent_on       Time.now
    body          :confirmation_url => reset_password_confirmation_account_path(:user => user.phone, :token => user.perishable_token)
  end
  
end
