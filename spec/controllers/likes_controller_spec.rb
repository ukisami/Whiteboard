require 'spec_helper'

describe LikesController do

  def mock_like(stubs={:ip => '1.1.1.1'})
    @mock_like ||= mock_model(Like, stubs)
  end

	def mock_gallery(stubs={})
    @mock_gallery ||= mock_model(Gallery, stubs)
  end

	def stub_get_gallery
    Gallery.stub!(:find).and_return(mock_gallery)
    mock_gallery.stub(:likes).and_return([])
		mock_gallery
  end

	describe "POST create" do
		before(:each) do
				stub_get_gallery
		end

		describe "with valid params" do
      it "assigns a newly created like as @like" do
        stub_get_gallery.likes.stub(:new).and_return(mock_like(:save => true))
				stub_get_gallery.likes.stub(:find_by_ip).and_return(nil)
				request = mock("request")
				request.stub(:remote_ip).and_return('1.1.1.1')
				@mock_like.stub(:ip=) 
        xhr :post, "create"
        assigns[:like].should equal(mock_like)
				
      end

      it "updates the text for likes" do
        stub_get_gallery.likes.stub(:new).and_return(mock_like(:save => true))
        page = mock("page")
				controller.should_receive(:render).with(:update).and_yield(page)
				page.stub(:replace_html)
				xhr :post, "create"
      end

    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved like as @like" do
        stub_get_gallery.likes.stub(:new).with({'these' => 'params'}).and_return(mock_like(:save => false))
        xhr :post, "create"
        assigns[:like].should equal(mock_like)
      end

      it "sets an error" do
        stub_get_gallery.likes.stub(:new).and_return(mock_like(:save => false))
       
				page = mock("page")
				controller.should_receive(:render).with(:update).and_yield(page)
				page.stub(:replace_html)
				xhr :post, "create"
      end
    end
	end

end
