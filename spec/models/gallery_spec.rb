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
end
