module UsersHelper
  
  def address_book_link
	  if current_user.contacts.find_by_associate_id(@user.id)
			"User is in your address book"
    else
		  link_to "Add to Address Book", contacts_path(:associate_id => @user.id), :method => :post
		end
  end
  
  def recommendation_link
	  if current_user.recommendations_given.find_by_user_id(@user.id)
			"You have recommended this user"
	  else
      link_to "Recommend this User", recommend_user_path(:user_id => @user.id), :method => :post
		end
  end
  
  def recommendations_count(user)
    "#{user.recommendations_received.all.length} recommendations"
  end
  
end

