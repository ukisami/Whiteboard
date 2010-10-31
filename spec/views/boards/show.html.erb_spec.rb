require 'spec_helper'

describe "/boards/show.html.erb" do
  include BoardsHelper
  before(:each) do
    assigns[:board] = @board = stub_model(Board)
  end

  it "renders attributes in <p>" do
    render
  end
end
