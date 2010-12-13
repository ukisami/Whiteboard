require 'spec_helper'

describe BoardsController do

  def mock_board(stubs={})
    @mock_board ||= mock_model(Board, stubs)
  end

  describe "GET show" do
    @layer = 1
    @token = 1

    it "assigns the requested board as @board" do
      Board.stub(:find).with("37").and_return(mock_board(:layer_from_token => @layer))
      get :show, :id => "37"
      assigns[:board].should equal(mock_board)
    end

    it "assigns the layer associated with given token as @current_layer" do
      Board.stub(:find).with("37").and_return(mock_board(:layer_from_token => @layer))
      get :show, :id => "37"
      assigns[:current_layer].should equal(@layer)
    end
  end

  describe "GET new" do
    it "assigns a new board as @board" do
      Board.stub(:new).and_return(mock_board)
      get :new
      assigns[:board].should equal(mock_board)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created board as @board" do
        Board.stub(:new).with({'these' => 'params'}).and_return(mock_board(:save => true, :owner_link => '/'))
        post :create, :board => {:these => 'params'}
        assigns[:board].should equal(mock_board)
      end

      it "redirects to the created board" do
        Board.stub(:new).and_return(mock_board(:save => true, :owner_link => '/'))
        post :create, :board => {}
        response.should redirect_to(mock_board.owner_link)
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

  describe "POST publish" do
    describe "with owner token" do
      it "should create a new gallery" do
        Board.should_receive(:find).with("37").and_return(mock_board)
        mock_board.stub(:permission).and_return(:owner)
        mock_board.stub(:galleries).and_return(Gallery)
        mock_board.should_receive(:galleries).and_return Gallery
        Gallery.should_receive(:create).and_return(mock_model(Gallery))
        post :publish, :id => "37", :revision => "1"
      end
    end

    describe "without owner token" do
      it "redirects to root path" do
        Board.should_receive(:find).and_return mock_board
        mock_board.stub(:permission).and_return(:viewer)
        post :publish, :id => "1"
        response.should redirect_to(root_path)
      end
    end
  end

  describe "GET poll" do
    describe "with valid revision" do
      it "should assign @board" do
        Board.should_receive(:find).with("37").and_return mock_board
        mock_board.should_receive(:table_of_updates_since_revision).with(1).and_return {}
        get :poll, :id => "37", :revision => "1"
      end
    end

    describe "with invalid revision" do
      it "Respond with Invalid Revision" do
        get :poll, :id => "37", :revision => "Hello"
        response.should have_text("Invalid Revision")
      end
    end
  end

  describe "PUT order" do

    before(:each) do
      Board.should_receive(:find).with("37").and_return mock_board
    end

    describe "with valid token" do
      before(:each) do
        mock_board.stub(:permission).and_return :owner
      end

      it "should assign @board" do
        mock_board.should_receive(:update_layer_orders).and_return true
        put :order, :id => "37"
        assigns[:board].should == mock_board
      end

      it "should call update layer orders and return success" do
        mock_board.should_receive(:update_layer_orders).and_return true
        put :order, :id => "37"
        response.should have_text("Success")
      end

      it "should call update layer orders and return failure" do
        mock_board.should_receive(:update_layer_orders).and_return false
        put :order, :id => "37"
        response.should have_text("Failure")
      end
    end

    describe "with invalid token" do
      it "should return invalid token" do
        mock_board.stub(:permission).and_return :collaborator
        put :order, :id => "37"
        response.should have_text("Invalid Token")
      end
    end
  end

end
