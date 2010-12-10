require 'spec_helper'

describe Layer do
  before(:each) do
    @valid_attributes = {

    }
  end

  it "should create a new instance given valid attributes" do
    Layer.create!(@valid_attributes)
  end

  it "should update data attribute when params with data" do
    layer = Layer.new
    value = 'test'
    layer.update_with_params({:data => value})
    layer.data.should == value
    layer.data_update.should == true
  end

  it "should update layerid attribute when given params with layerid" do
    layer = Layer.new
    value = '1'
    layer.update_with_params({:layerid => value})
    layer.layerid.should == value.to_i
    layer.layerid_update.should == true
  end

  it "should update opacity attribute when given params with opacity" do
    layer = Layer.new
    value = '1'
    layer.update_with_params({:opacity => value})
    layer.opacity.should == value.to_i
    layer.opacity_update.should == true
  end

  it "should update visible attribute when given params with visible" do
    layer = Layer.new
    value = 'true'
    layer.update_with_params({:visible => value})
    layer.visible.should == true
    layer.visible_update.should == true
  end

  it "should set last_data_update when given no data but data_update is true" do
    layer = Layer.new
    layer.updated_at = DateTime.now
    layer.data_update = true
    layer.update_with_params({})
    layer.data_update.should == false
    layer.last_data_update.should == layer.updated_at
  end

  it "should prepare a table with only data if only data is updated" do
    layer = Layer.new
    value = 'test'
    time = Time.now.utc
    layer.last_data_update = 1.seconds.from_now.utc
    layer.data = value
    layer.prepare_table(time.to_i)[:data].should == value
  end

  it "should prepare a table with only visible if only visible is updated" do
    layer = Layer.new
    value = true
    time = Time.now.utc
    layer.visible_update = true
    layer.visible = value
    layer.prepare_table(time.to_i)[:visible].should == value
  end
end
