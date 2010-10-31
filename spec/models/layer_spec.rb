require 'spec_helper'

describe Layer do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Layer.create!(@valid_attributes)
  end
end
