require 'spec_helper'

describe "/boards/edit.html.erb" do
  include BoardsHelper

  before(:each) do
    assigns[:board] = @board = stub_model(Board,
      :new_record? => false
    )
  end

  it "renders the edit board form" do
    render

    response.should have_tag("form[action=#{board_path(@board)}][method=post]") do
    end
  end
end
