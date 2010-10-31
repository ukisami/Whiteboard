require 'spec_helper'

describe BoardsController do

  def mock_board(stubs={})
    @mock_board ||= mock_model(Board, stubs)
  end

  describe "GET index" do
    it "assigns all boards as @boards" do
      Board.stub(:find).with(:all).and_return([mock_board])
      get :index
      assigns[:boards].should == [mock_board]
    end
  end

  describe "GET show" do
    it "assigns the requested board as @board" do
      Board.stub(:find).with("37").and_return(mock_board)
      get :show, :id => "37"
      assigns[:board].should equal(mock_board)
    end
  end

  describe "GET new" do
    it "assigns a new board as @board" do
      Board.stub(:new).and_return(mock_board)
      get :new
      assigns[:board].should equal(mock_board)
    end
  end

  describe "GET edit" do
    it "assigns the requested board as @board" do
      Board.stub(:find).with("37").and_return(mock_board)
      get :edit, :id => "37"
      assigns[:board].should equal(mock_board)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created board as @board" do
        Board.stub(:new).with({'these' => 'params'}).and_return(mock_board(:save => true))
        post :create, :board => {:these => 'params'}
        assigns[:board].should equal(mock_board)
      end

      it "redirects to the created board" do
        Board.stub(:new).and_return(mock_board(:save => true))
        post :create, :board => {}
        response.should redirect_to(board_url(mock_board))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved board as @board" do
        Board.stub(:new).with({'these' => 'params'}).and_return(mock_board(:save => false))
        post :create, :board => {:these => 'params'}
        assigns[:board].should equal(mock_board)
      end

      it "re-renders the 'new' template" do
        Board.stub(:new).and_return(mock_board(:save => false))
        post :create, :board => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested board" do
        Board.should_receive(:find).with("37").and_return(mock_board)
        mock_board.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :board => {:these => 'params'}
      end

      it "assigns the requested board as @board" do
        Board.stub(:find).and_return(mock_board(:update_attributes => true))
        put :update, :id => "1"
        assigns[:board].should equal(mock_board)
      end

      it "redirects to the board" do
        Board.stub(:find).and_return(mock_board(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(board_url(mock_board))
      end
    end

    describe "with invalid params" do
      it "updates the requested board" do
        Board.should_receive(:find).with("37").and_return(mock_board)
        mock_board.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :board => {:these => 'params'}
      end

      it "assigns the board as @board" do
        Board.stub(:find).and_return(mock_board(:update_attributes => false))
        put :update, :id => "1"
        assigns[:board].should equal(mock_board)
      end

      it "re-renders the 'edit' template" do
        Board.stub(:find).and_return(mock_board(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested board" do
      Board.should_receive(:find).with("37").and_return(mock_board)
      mock_board.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the boards list" do
      Board.stub(:find).and_return(mock_board(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(boards_url)
    end
  end

end
