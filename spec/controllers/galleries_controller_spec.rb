require 'spec_helper'

describe GalleriesController do

  def mock_gallery(stubs={})
    @mock_gallery ||= mock_model(Gallery, stubs)
  end

  describe "GET index" do
		before :each do
			gallery1 = Gallery.create(:totalView => '1')
			gallery2 = Gallery.create(:totalView => '2')
			@galleries1 = [gallery1, gallery2]
			@galleries2 = [gallery2, gallery1]
      Gallery.stub(:find).with(:all).and_return(@galleries1)
			Gallery.stub(:all).and_return(@galleries1)
			mock_gallery.stub(:updateRecValue)
			mock_gallery.stub(:save)
		end 

    it "assigns all galleries as @galleries and sorts by views" do
      get :index, :sort => "byViews"
      assigns[:galleries].should equal(@galleries1)
    end

		it "assigns all galleries as @galleries and sorts by dates" do
      get :index
      assigns[:galleries].should equal(@galleries1)
    end

		it "assigns all galleries as @galleries and sorts by Rec" do
      get :index, :sort => "byRec"
      assigns[:galleries].should equal(@galleries1)
    end

		it "assigns all galleries as @galleries and sorts by anything else" do
      get :index, :sort => "anything else"
      assigns[:galleries].should equal(@galleries1)
    end
  end

  describe "GET show" do
    it "assigns the requested gallery as @gallery" do
      Gallery.stub(:find).with("37").and_return(mock_gallery)
			mock_gallery.stub(:incOne)
			mock_gallery.stub(:updateRecValue)
			mock_gallery.stub(:save).and_return(true)
      get :show, :id => "37"
      assigns[:gallery].should equal(mock_gallery)
    end
  end

  describe "POST create" do

  	before :each do
  		board = Board.create(:title => 'sentinel')
  		@token = board.token
  		@b_id = board.id
  		board.save
  	end

    describe "with valid params" do
      it "assigns a newly created gallery as @gallery" do
        post :create, :board_id => @b_id, :token => @token
        assigns[:gallery].should_not equal(nil)
      end
    end

    describe "with invalid params" do
      it "redirects to the homepage" do
        Gallery.stub(:new).and_return(mock_gallery(:save => false))
        post :create, :board_id => 1, :token => @token
        response.should redirect_to '/'
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

	describe "search" do

		it "assigns the search results to @galleries" do
			board1 = Board.create(:title => 'yo sup')
			board2 = Board.create(:title => 'yo heelo')
			board3 = Board.create(:title => 'ni hao')
			post :search, :search => 'yo'
			response.should render_template 'index'
		end
	end

end
