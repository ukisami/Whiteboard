require 'spec_helper'

describe "/boards/index.html.erb" do
  include BoardsHelper

  before(:each) do
    assigns[:boards] = [
      stub_model(Board),
      stub_model(Board)
    ]
  end

  it "renders a list of boards" do
    render
  end
end
