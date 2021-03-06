require 'spec_helper'

describe CommentsController do

  def mock_comment(stubs={})
    @mock_comment ||= mock_model(Comment, stubs)
  end

	def mock_gallery(stubs={})
    @mock_gallery ||= mock_model(Gallery, stubs)
  end

	def stub_get_gallery
    Gallery.stub!(:find).and_return(mock_gallery)
    mock_gallery.stub(:comments).and_return([])
    mock_gallery.stub(:id).and_return('33')
		mock_gallery
  end

	def get_gallery
		@gallery = Board.create(:title => "aa").galleries.create
	end

  describe "GET index" do
    it "assigns all comments as @comments" do
      Comment.stub(:find).with(:all).and_return([mock_comment])
      get :index
      assigns[:comments].should == [mock_comment]
    end
  end

  describe "GET show" do
    it "assigns the requested comment as @comment" do
      Comment.stub(:find).with("37").and_return(mock_comment)
      get :show, :id => "37"
      assigns[:comment].should equal(mock_comment)
    end
  end

  describe "GET new" do
    it "assigns a new comment as @comment" do
      Comment.stub(:new).and_return(mock_comment)
      get :new
      assigns[:comment].should equal(mock_comment)
    end
  end

  describe "GET edit" do
    it "assigns the requested comment as @comment" do
      Comment.stub(:find).with("37").and_return(mock_comment)
      get :edit, :id => "37"
      assigns[:comment].should equal(mock_comment)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created comment as @comment" do
        Comment.stub(:new).with({'these' => 'params'}).and_return(mock_comment(:save => true))
        post :create, :comment => {:these => 'params'}
        assigns[:comment].should equal(mock_comment)
      end

      it "redirects to the created comment" do
        Comment.stub(:new).and_return(mock_comment(:save => true))
        post :create, :comment => {}
        response.should redirect_to(comment_url(mock_comment))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved comment as @comment" do
        Comment.stub(:new).with({'these' => 'params'}).and_return(mock_comment(:save => false))
        post :create, :comment => {:these => 'params'}
        assigns[:comment].should equal(mock_comment)
      end

      it "re-renders the 'new' template" do
        Comment.stub(:new).and_return(mock_comment(:save => false))
        post :create, :comment => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested comment" do
        Comment.should_receive(:find).with("37").and_return(mock_comment)
        mock_comment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :comment => {:these => 'params'}
      end

      it "assigns the requested comment as @comment" do
        Comment.stub(:find).and_return(mock_comment(:update_attributes => true))
        put :update, :id => "1"
        assigns[:comment].should equal(mock_comment)
      end

      it "redirects to the comment" do
        Comment.stub(:find).and_return(mock_comment(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(comment_url(mock_comment))
      end
    end

    describe "with invalid params" do
      it "updates the requested comment" do
        Comment.should_receive(:find).with("37").and_return(mock_comment)
        mock_comment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :comment => {:these => 'params'}
      end

      it "assigns the comment as @comment" do
        Comment.stub(:find).and_return(mock_comment(:update_attributes => false))
        put :update, :id => "1"
        assigns[:comment].should equal(mock_comment)
      end

      it "re-renders the 'edit' template" do
        Comment.stub(:find).and_return(mock_comment(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested comment" do
      Comment.should_receive(:find).with("37").and_return(mock_comment)
      mock_comment.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the comments list" do
      Comment.stub(:find).and_return(mock_comment(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(comments_url)
    end
  end

	describe "add_comment" do

		describe "with valid gallery" do
			before(:each) do
				stub_get_gallery
			end
    	it "creates a new comment if saved correctly" do
				mc = mock_comment(:save => true, :created_at => Time.now, :content => 'a')
				stub_get_gallery.comments.stub(:new).and_return(mc)
        xhr :post, "add_comment"
        assigns[:comment].should equal(mc)
    	end

			it "sets an error" do 
				mc = mock_comment(:save => false)
				stub_get_gallery.comments.stub(:new).and_return(mc)
				el = mock("errors")
				el.stub(:on).and_return("gogogo")
				mc.stub(:errors).and_return(el)
				page = mock("page")
				controller.should_receive(:render).with(:update).and_yield(page)
				page.stub(:replace_html)
				page.stub(:<<)
				xhr :post, "add_comment"
			end

    	it "redirects to the created comment" do
        mock_gallery.comments.stub(:new).and_return(mock_comment(:save => true))
				page = mock("page")
				controller.should_receive(:render).with(:update).and_yield(page)
				page.should_receive(:insert_html).with(:before, "add_comment_33", :partial => 'comments/comment', :locals => { :comment => mock_comment })
				el = mock("textarea")
				el.should_receive(:clear)
				page.stub(:[]).and_return(el) 
				page.should_receive(:replace_html).with("comment_errors", :text => "")
				page.stub(:<<)
        xhr :post, 'add_comment'
      end
			
		end
		
		describe "with invalid gallery" do
      it "redirect to root path" do
        Gallery.stub(:find).and_raise "Exception"
        post :add_comment
        response.should redirect_to root_path
      end
		end
  end

	describe "show_more comments" do
		it "updates the page correctly" do
			stub_get_gallery			
			page = mock("page")
    	controller.should_receive(:render).with(:update).and_yield(page)
    	page.should_receive(:replace_html).with("comments_for_33", :partial => stub_get_gallery.comments)
				#response.should have_rjs(:chained_replace_html, 'comments_for_33', 'some text')
			xhr :post, 'show_more'
		end
	end

end
