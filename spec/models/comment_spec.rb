require 'spec_helper'

describe Comment do
  before(:each) do
    @valid_attributes = {
      :content => "value for content",
      :gallery_id => 1,
      :comment_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Comment.create!(@valid_attributes)
  end
end
