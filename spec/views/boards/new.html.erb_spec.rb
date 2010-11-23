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
  
  it "renders new board form with errors" do
  	errors_stub = mock(:on => 'lol')
  	assigns[:board].stub(:errors).and_return(errors_stub)
  	render
  	response.should have_tag("span") do
  	end
  end
end
