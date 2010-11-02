require 'spec_helper'

describe Board do
  before(:each) do
    @valid_attributes = {
      :title => 'untitled'
    }
  end

  it "should create a new instance given valid attributes" do
    Board.create!(@valid_attributes)
  end
end
