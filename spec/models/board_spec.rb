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

  it "should return polymorphic path when asked about viewer_link" do
    board = Board.new
    board.stub(:polymorphic_path).and_return(1)
    board.viewer_link.should equal(1)
  end

  describe "with updated layers" do
    before(:each) do
      @board = Board.create(@valid_attributes)
      time_i = DateTime.now.to_i
      time1 = 1.seconds.from_now
      time2 = 2.seconds.from_now
      @revision1 = time_i
      @layer1 = @board.layers.create(:name => "1", :updated_at =>time1)
      @revision2 = DateTime.now.to_i + 1
      @layer2 = @board.layers.create(:name => "2", :updated_at =>time2)
      @revision3 = DateTime.now.to_i + 2
    end

    it "should return @layer1 and @layer2 when asked for layers updated after @revision1" do
      @board.layers_updated_after_revision(@revision1).should include(@layer1)
      @board.layers_updated_after_revision(@revision1).should include(@layer2)
    end

    it "should return @layer2 only when asked for layers updated after @revision2" do
      @board.layers_updated_after_revision(@revision2).should_not include(@layer1)
      @board.layers_updated_after_revision(@revision2).should include(@layer2)
    end

    it "should return empty array when asked for layers updated after @revision3" do
      @board.layers_updated_after_revision(@revision3).should_not include(@layer1)
      @board.layers_updated_after_revision(@revision3).should_not include(@layer2)
    end
  end

  describe "with updated chats" do
    before(:each) do
      @board = Board.create(@valid_attributes)
      time_i = DateTime.now.to_i
      time1 = 1.seconds.from_now
      time2 = 2.seconds.from_now
      @revision1 = time_i
      @chat1 = @board.chats.create(:author => "h", :body => "a", :created_at => time1)
      @revision2 = time_i + 1
      @chat2 = @board.chats.create(:author => "h", :body => "i", :created_at => time2)
      @revision3 = time_i + 2
    end

    it "should return @chat1 and @chat2 when asked for chats updated after @revision1" do
      @board.chats_created_after_revision(@revision1).should include(@chat1)
      @board.chats_created_after_revision(@revision1).should include(@chat2)
    end

    it "should return @chat2 only when asked for chats updated after @revision2" do
      @board.chats_created_after_revision(@revision2).should_not include(@chat1)
      @board.chats_created_after_revision(@revision2).should include(@chat2)
    end

    it "should return empty array when asked for chats created after @revision3" do
      @board.chats_created_after_revision(@revision3).should_not include(@chat1)
      @board.chats_created_after_revision(@revision3).should_not include(@chat2)
    end
  end

  describe "given latest layers and chats" do
    before(:each) do
      @board = Board.create @valid_attributes
      @revision = DateTime.now.to_i - 1
      @layers = [@board.layers.create(:name => "1")]
      @layers << @board.layers.create(:name => "2")
      @layers[0].data = "0"
      @layers[1].data = "1"
      @layers[0].save
      @layers[1].save
      @chats = [@board.chats.create(:author => "1")]
      @board.stub(:layers_updated_after_revision).and_return @layers
      @board.stub(:chats_created_after_revision).and_return @chats
    end

    it "should return a table of updates containing @layers and @chats when asked about its table of updates since @revision" do
      @updates = @board.table_of_updates_since_revision(@revision)
      @updates[:revision].should equal(@chats[0].created_at.to_i)
      @updates[:layers][@layers[0].id].should equal @layers[0].data
      @updates[:layers][@layers[1].id].should equal @layers[1].data
      @updates[:chats][0][:author].should equal @chats[0].author
    end
  end

end
