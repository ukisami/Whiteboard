require 'spec_helper'

describe LayersController do

  def mock_layer(stubs={:save => true})
    @mock_layer ||= mock_model(Layer, stubs)
  end

  def mock_board(stubs={})
    @mock_board ||= mock_model(Board, stubs)
  end

  def stub_get_board
    Board.stub!(:find).and_return(mock_board)
    mock_board.stub(:layers).and_return([])
    mock_board.stub(:owner_link).and_return('/')
  end

  def stub_require_token
    mock_board.stub(:permission).and_return(:owner)
  end

  describe "GET new" do
    describe "with valid board" do
      it "assigns a new layer as @layer" do
        stub_get_board
        mock_board.layers.stub(:new).and_return(mock_layer)
        get :new
        assigns[:layer].should equal(mock_layer)
      end
    end

    describe "with invalid board" do
      it "assigns a new layer as @layer" do
        Board.stub(:find).and_raise "Exception"
        get :new
        response.should redirect_to root_path
      end
    end
  end

  describe "POST create" do


    describe "with valid params" do
      it "assigns a newly created layer as @layer" do
        stub_get_board
        stub_require_token
        mock_board.layers.stub(:new).with({'these' => 'params'}).and_return(mock_layer(:save => true))
        post :create, :layer => {:these => 'params'}
        assigns[:layer].should equal(mock_layer)
      end

      it "redirects to the creating board" do
        stub_get_board
        stub_require_token
        mock_board.layers.stub(:new).and_return(mock_layer(:save => true))
        post :create, :layer => {}
        response.should redirect_to(mock_board.owner_link)
      end

    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved layer as @layer" do
        stub_get_board
        stub_require_token
        mock_board.layers.stub(:new).with({'these' => 'params'}).and_return(mock_layer(:save => false))
        post :create, :layer => {:these => 'params'}
        assigns[:layer].should equal(mock_layer)
      end

      it "re-renders the 'new' template" do
        stub_get_board
        stub_require_token
        mock_board.layers.stub(:new).and_return(mock_layer(:save => false))
        post :create, :layer => {}
        response.should render_template('new')
      end
    end

    describe "without valid token" do
      it "redirect to root path" do
        stub_get_board
        mock_board.stub(:permission).and_return(:viewer)
        post :create, :layer => {:these => 'params'}
        response.should redirect_to(root_path)
      end
    end
  end

  describe "PUT update" do
    @valid_token = "valid"
    @old_data  = 0
    @new_data  = 1

    def stub_layer_token
      mock_layer.stub(:token).and_return @valid_token
    end

    def stub_layer_data
      mock_layer.stub(:data).and_return @old_data
      mock_layer.stub(:data=).and_return Proc.new {|data|
        mock_layer.stub(:data).and_return @new_data}
    end

    before(:each) do
      stub_get_board
      stub_require_token
      stub_layer_token
      stub_layer_data
    end

    describe "with valid token" do
      it "should find the corresponding layer" do
        mock_board.layers.should_receive(:find).with("37").and_return(mock_layer)
        put :update, :id => "37", :layer => {:these => 'params'}, :token => @valid_token
      end

      it "shoud assign the requested layer as @layer" do
        mock_board.layers.stub(:find).and_return(mock_layer)
        put :update, :id => "1", :token => @valid_token
        assigns[:layer].should equal(mock_layer)
      end

      it "should assign @layer.data to params[:data] if present" do
        mock_board.layers.stub(:find).and_return mock_layer
        mock_layer.should_receive(:data=).with(@new_data)
        mock_layer.should_receive(:save).and_return(true)
        put :update, :id => "1", :token => @valid_token, :data => @new_data
        mock_layer.data.should equal(@new_data)
      end

      it "should not change @layer.data if params[:data] is not present" do
        mock_board.layers.stub(:find).and_return(mock_layer)
        mock_layer.should_receive(:data=).with(nil)
        put :update, :id => "1", :token => @valid_token
        mock_layer.data.should equal(@old_data)
      end
    end

    describe "without valid token" do
      it "redirect to root path" do
        mock_board.stub(:permission).and_return(:viewer)
        post :create, :layer => {:these => 'params'}
        response.should redirect_to(root_path)
      end
    end
  end

  describe "DELETE destroy" do

    before(:each) do
      stub_get_board
      stub_require_token
    end

    it "destroys the requested layer" do
      mock_board.layers.should_receive(:find).with("37").and_return(mock_layer)
      mock_layer.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the layers list" do
      mock_board.layers.stub(:find).and_return(mock_layer(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(layers_url)
    end
  end

end
