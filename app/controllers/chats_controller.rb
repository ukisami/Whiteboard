class ChatsController < ApplicationController

  # POST /boards
  # POST /boards.xml
  def create
    @chat = Chat.new(params[:chat])
    respond_to do |format|
      if @chat.save
        format.html { render :text => "Success" }
        format.xml  { render :xml => @chat, :status => :created}
      else
        format.html { render :text => "Failed" }
        format.xml  { render :xml => @chat.errors, :status => :unprocessable_entity }
      end
    end
  end
end
