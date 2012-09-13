class MessagesController < ApplicationController
  #before_filter :require_user, :except => [:index, :show]
  #before_filter :content_owner, :only => [:edit, :update, :destroy]
  layout "plain_text"
  
  def post
    @message = Message.new(:message => params[:message], :msisdn => params[:msisdn])
    @message.msisdn = @message.msisdn.gsub(/^(960|\+960)/, "")
    @saved = @message.save
    if @saved       
      @message.process
      @response = @message.response
      if @response == false
        @response = 'Could not process message. Available commands are: reg, find, search, sell, buy, password reset, update, sold, del, recommend and help. For command help send "help [command]".'
      end
    else
      @response = "Invalid message."      
      if @message.errors
        @response = @message.errors.first.last
      end
    end
    
    # redirect_to reply_messages_path(:response => @response)
    #@response = "INVALID INPUT"    
    redirect_to :controller => :messages, :action => :reply, :response => @response
  end
  
  def reply
    @response = params[:response]
  end

end
