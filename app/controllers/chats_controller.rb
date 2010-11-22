class ChatsController < ApplicationController
  protect_from_forgery :except => [:create]

  def create
    @board = Board.find params[:board_id]
    layer = @board.layer_from_token(params[:token])
    @chat = nil
    if layer
      @chat = @board.chats.new :author => layer.name, :body => params[:body]
    end

    respond_to do |format|
      if @chat and @chat.save
        format.xml  { head :ok }
      end
    end
  end
end
