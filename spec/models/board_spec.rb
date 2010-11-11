require 'spec_helper'

describe Board do
  before(:each) do
    @valid_attributes = {
      :title => 'untitled'
    }
  end

  def mock_layer(stubs={})
    @mock_layer ||= mock_model(Layer, stubs)
  end

  def mock_layer2(stubs={})
    @mock_layer2 ||= mock_model(Layer, stubs)
  end

  it "should create a new instance given valid attributes" do
    Board.create!(@valid_attributes)
  end

  it "should returns the first layer when asked for base_layer" do 
	board = Board.new
    board.stub(:layers).and_return([mock_layer, mock_layer2])
	board.base_layer.should equal mock_layer
  end

  it "should return base_layer's token when asked for token" do
	board = Board.new
	token = "sss"
	board.stub(:base_layer).and_return(mock_layer)
	mock_layer.stub(:token).and_return(token)
	board.token.should equal token
  end

  it "should return polymorphic path when given token" do
	board = Board.new
	path = "/"
	token = "what"
	board.stub(:token).and_return(token)
	board.stub(:polymorphic_path).and_return(path)
	board.owner_link.should == path
  end

  it "should return owner when given token is equal to board's token" do
	board = Board.new
	token = "what"
	board.stub(:token).and_return(token)
	board.permission(token).should equal :owner
  end
end
