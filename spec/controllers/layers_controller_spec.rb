require 'spec_helper'

describe LayersController do

  def mock_layer(stubs={})
    @mock_layer ||= mock_model(Layer, stubs)
  end

  def mock_board(stubs={})
    @mock_board ||= mock_model(Board, stubs)
  end

  def stub_get_board
    Board.stub!(:find).and_return(mock_board)
    mock_board.stub(:layers).and_return([mock_layer])
    mock_board.stub(:owner_link).and_return('/')
  end

  describe "GET index" do
    it "given board, assigns its layers as @layers" do
      stub_get_board
      mock_board.layers.stub(:all).and_return([mock_layer])
      get :index
      assigns[:layers].should == [mock_layer]
    end
  end

  describe "GET new" do
    it "assigns a new layer as @layer" do
      stub_get_board
      mock_board.layers.stub(:new).and_return(mock_layer)
      get :new
      assigns[:layer].should equal(mock_layer)
    end
  end

  describe "GET edit" do
    it "assigns the requested layer as @layer" do
      stub_get_board
      mock_board.layers.stub(:find).with("37").and_return(mock_layer)
      get :edit, :id => "37"
      assigns[:layer].should equal(mock_layer)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created layer as @layer" do
        stub_get_board
        mock_board.layers.stub(:new).with({'these' => 'params'}).and_return(mock_layer(:save => true))
        post :create, :layer => {:these => 'params'}
        assigns[:layer].should equal(mock_layer)
      end

      it "redirects to the creating board" do
        stub_get_board
        mock_board.layers.stub(:new).and_return(mock_layer(:save => true))
        post :create, :layer => {}
        response.should redirect_to(mock_board.owner_link)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved layer as @layer" do
        Layer.stub(:new).with({'these' => 'params'}).and_return(mock_layer(:save => false))
        post :create, :layer => {:these => 'params'}
        assigns[:layer].should equal(mock_layer)
      end

      it "re-renders the 'new' template" do
        Layer.stub(:new).and_return(mock_layer(:save => false))
        post :create, :layer => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested layer" do
        Layer.should_receive(:find).with("37").and_return(mock_layer)
        mock_layer.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :layer => {:these => 'params'}
      end

      it "assigns the requested layer as @layer" do
        Layer.stub(:find).and_return(mock_layer(:update_attributes => true))
        put :update, :id => "1"
        assigns[:layer].should equal(mock_layer)
      end

      it "redirects to the layer" do
        Layer.stub(:find).and_return(mock_layer(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(layer_url(mock_layer))
      end
    end

    describe "with invalid params" do
      it "updates the requested layer" do
        Layer.should_receive(:find).with("37").and_return(mock_layer)
        mock_layer.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :layer => {:these => 'params'}
      end

      it "assigns the layer as @layer" do
        Layer.stub(:find).and_return(mock_layer(:update_attributes => false))
        put :update, :id => "1"
        assigns[:layer].should equal(mock_layer)
      end

      it "re-renders the 'edit' template" do
        Layer.stub(:find).and_return(mock_layer(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested layer" do
      stub_get_board
      mock_board.should_receive(:find).with("37").and_return(mock_layer)
      mock_layer.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the layers list" do
      stub_get_board
      mock_board.stub(:find).and_return(mock_layer(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(layers_url)
    end
  end

end
