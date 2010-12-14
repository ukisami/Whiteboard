require 'spec_helper'

describe Gallery do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Gallery.create!(@valid_attributes)
  end
  
  it "should proxy :title to its board" do
  	board = Board.create(:title => 'correct')
  	gallery = board.galleries.create(@valid_attributes)
  	gallery.title.should == 'correct'
  end

	describe "when a gallery is viewed" do

		it "should increase total view by 1 if it has been viewed" do
			gallery = Gallery.create!(@valid_attributes)
			gallery.stub(:totalView).and_return(2)
			gallery.incOne.should equal(3)
		end

		it "should increate total view to 1 if it has not been viewed" do
			gallery = Gallery.create!(@valid_attributes)
			gallery.stub(:totalView).and_return(nil)
			gallery.incOne.should equal(1)
		end

	end

	it "should update Rec value" do
		gallery = Gallery.create!(@valid_attributes)
		likes = []
		gallery.recValue = 0
		gallery.stub(:likes).and_return(likes)
		gallery.likes.stub(:count).and_return(3)
		gallery.stub(:totalView).and_return(1)		
		gallery.updateRecValue
		gallery.recValue.should == 61
	end

end
