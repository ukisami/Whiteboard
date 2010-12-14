require 'spec_helper'

describe Board do
  before(:each) do
    @valid_attributes = {
      :title => 'untitled'
    }
		@kkk_titled = {
			:title => 'kkk'
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

  it "should create a new layer with order 0" do
    board = Board.create!(@valid_attributes)
    board.layers.first.order.should == 0
  end

  it "should return 1 as next order number after creation" do
    board = Board.create!(@valid_attributes)
    board.next_order_number.should == 1
  end

  it "should return 2 as next order number after a new layer is added" do
    board = Board.create!(@valid_attributes)
    board.layers.create()
    board.next_order_number.should == 2
  end

  it "should return 1 as order number of the second layer" do
    board = Board.create!(@valid_attributes)
    board.layers.create()
    board.layers.last.order.should == 1
  end

  it "should returns the first layer when asked for base_layer" do 
    board = Board.new
    board.layers.stub(:first).and_return(mock_layer)
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

  describe "on validating layer orders" do
    before(:each) do
      @board = Board.new
    end

    it "should return false on valid_layer_ords when a layer has order too small" do
      @board.layers.build(:order => -1)
      @board.validate_layer_orders.should == false
    end

    it "should return false on valid_layer_ords when a layer has order too big" do
      @board.layers.build(:order => 1)
      @board.validate_layer_orders.should == false
    end

    it "should return false on valid_layer_ords when layer orders contains duplicates" do
      @board.layers.build(:order => 1)
      @board.layers.build(:order => 0)
      @board.layers.build(:order => 1)
      @board.validate_layer_orders.should == false
    end

    it "should return true on valid_layer_ords when layer orders are valid" do
      @board.layers.build(:order => 1)
      @board.layers.build(:order => 0)
      @board.validate_layer_orders.should == true
    end
  end

  describe "on updating layer orders" do
    before(:each) do
      @board = Board.create(@valid_attributes)
      @layer1 = @board.layers.first
      @layer2 = @board.layers.create(:order => 1)
      @layer3 = @board.layers.create(:order => 2)
    end

    it "should swap layer1 and layer2's order given certain params" do
      oldorder1 = @layer1.order
      oldorder2 = @layer2.order
      params = {@layer1.id.to_s => oldorder2, @layer2.id.to_s => oldorder1}
      @board.update_layer_orders(params).should == true
      @layer1.order.should == oldorder2
      @layer2.order.should == oldorder1
    end

    it "should swap layer1 and layer3's order given certain params" do
      oldorder1 = @layer1.order
      oldorder3 = @layer3.order
      params = {@layer1.id.to_s => oldorder3, @layer3.id.to_s => oldorder1}
      @board.update_layer_orders(params).should == true
      @layer1.order.should == oldorder3
      @layer3.order.should == oldorder1
    end

    it "should return false with invalid order params" do
      oldorder1 = @layer1.order
      oldorder2 = @layer2.order
      oldorder3 = @layer3.order
      params = {@layer1.id.to_s => 1, @layer3.id.to_s => 1}
      @board.update_layer_orders(params).should == false
      @layer1.reload.order.should == oldorder1
      @layer2.reload.order.should == oldorder2
      @layer3.reload.order.should == oldorder3
    end

    it "should return false with invalid order params" do
      oldorder1 = @layer1.order
      oldorder2 = @layer2.order
      oldorder3 = @layer3.order
      params = {@layer1.id.to_s => -1}
      @board.update_layer_orders(params).should == false
      @layer1.reload.order.should == oldorder1
      @layer2.reload.order.should == oldorder2
      @layer3.reload.order.should == oldorder3
    end
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
      @layers[0].data_update = true
      @layers[1].data_update = true
      @layers[0].save
      @layers[1].save
      @chats = [@board.chats.create(:author => "1")]
      @board.stub(:layers_updated_after_revision).and_return @layers
      @board.stub(:chats_created_after_revision).and_return @chats
    end

    it "should return a table of updates containing @layers and @chats when asked about its table of updates since @revision" do
      @updates = @board.table_of_updates_since_revision(@revision)
      @updates[:revision].should == @chats[0].created_at.to_i
      @updates[:layers][@layers[0].id][:data].should equal @layers[0].data
      @updates[:layers][@layers[1].id][:data].should equal @layers[1].data
      @updates[:chats][0][:author].should equal @chats[0].author
    end
  end

	describe "given we want to search for boards" do
		it "should return boards titled 'kkk' if 'kkk' is the input" do
			@board = Board.create @kkk_titled
			params = 'kkk'
			Board.search(params).should include(@board)
		end

		it "should return all all if nothing is inputted" do
			@board1 = Board.create @valid_attributes
			@board2 = Board.create @kkk_titled
			boards = Board.search('')
			boards.should include(@board1)
			boards.should include(@board2)
		end
	end

end
