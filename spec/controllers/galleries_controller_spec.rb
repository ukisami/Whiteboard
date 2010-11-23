require 'spec_helper'

describe GalleriesController do

  def mock_gallery(stubs={})
    @mock_gallery ||= mock_model(Gallery, stubs)
  end

  describe "GET index" do
    it "assigns all galleries as @galleries" do
      Gallery.stub(:all).and_return([mock_gallery])
      get :index
      assigns[:galleries].should == [mock_gallery]
    end
  end

  describe "GET show" do
    it "assigns the requested gallery as @gallery" do
      Gallery.stub(:find).with("37").and_return(mock_gallery)
      get :show, :id => "37"
      assigns[:gallery].should equal(mock_gallery)
    end
  end

  describe "POST create" do

  	before :each do
  		board = Board.create(:title => 'sentinel')
  		@token = board.token
  	end

    describe "with valid params" do
      it "assigns a newly created gallery as @gallery" do
        Gallery.stub(:new).and_return(mock_gallery(:save => true))
        post :create, :board_id => 1, :token => @token
        assigns[:gallery].should equal(mock_gallery)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved gallery as @gallery" do
        Gallery.stub(:new).and_return(mock_gallery(:save => false))
        post :create, :board_id => 1, :token => @token
        assigns[:gallery].should equal(mock_gallery)
      end
    end
    
    describe "without the owner token" do
	    it "redirects to the home page" do
        Gallery.stub(:new).and_return(mock_gallery(:save => false))
        post :create, :board_id => 1, :token => 'lol'
        response.should redirect_to '/'
	    end
    end

  end

end
