class MessageController < ApplicationController

  require 'carapace'
  include Carapace

  def index
    carapace_session
    if request.post?
      @message=params[:message]
      carapace_decrypt! @message
    end 
  end 
end
