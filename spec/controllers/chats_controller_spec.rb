require 'spec_helper'

describe ChatsController do


  def mock_board(stubs={})
    @mock_board ||= mock_model(Board, stubs)
  end

  def mock_chat(stubs={})
    @mock_chat ||= mock_model(Comment, stubs)
  end

  def mock_layer(stubs={})
    @mock_layer ||= mock_model(Layer, stubs)
  end

  describe "POST create" do
    before(:each) do
      Board.should_receive(:find).with("1").and_return(mock_board)
      mock_board.should_receive(:chats).and_return(Chat)
      Chats.should_receive(:new).and_return(mock_chat)
    end

    describe "with valid params" do
      it "assigns @board" do
        mock_board.should_receive(:layer_from_token).and_return(nil)
        @chat.should_receive(:save).and_return
        post :create, :board_id => "1"
        assigns[:board].should == mock_board
      end

      it "assigns @layer" do
        mock_board.should_receive(:layer_from_token).and_return(nil)
        @chat.should_receive(:save).and_return
        post :create, :board_id => "1"
        assigns[:board].should == mock_board
      end
      end
    end
  end

end
