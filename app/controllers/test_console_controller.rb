class TestConsoleController < ApplicationController
  
  def index
  end
  
  def test
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
    
    render "index"
  end
  
end
