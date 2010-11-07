require 'spec_helper'

describe Publication do
  before(:each) do
    @valid_attributes = {
      :title => "value for title",
      :image => "value for image",
      :board_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Publication.create!(@valid_attributes)
  end
end
