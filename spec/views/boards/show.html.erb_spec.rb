require 'spec_helper'

describe "/boards/show.html.erb" do
  include BoardsHelper
  before(:each) do
    assigns[:board] = @board = stub_model(Board)
    @board.stub(:token).and_return("asdk")
  end

  it "renders attributes in <p>" do
    render
  end
end


