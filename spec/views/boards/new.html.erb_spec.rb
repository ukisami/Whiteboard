require 'spec_helper'

describe "/boards/new.html.erb" do
  include BoardsHelper

  before(:each) do
    assigns[:board] = stub_model(Board,
      :new_record? => true
    )
  end

  it "renders new board form" do
    render

    response.should have_tag("form[action=?][method=post]", boards_path) do
    end
  end
end
