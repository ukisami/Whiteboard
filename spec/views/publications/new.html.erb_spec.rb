require 'spec_helper'

describe "/publications/new.html.erb" do
  include PublicationsHelper

  before(:each) do
    assigns[:publication] = stub_model(Publication,
      :new_record? => true,
      :title => "value for title",
      :image => "value for image",
      :board => 1
    )
  end

  it "renders new publication form" do
    render

    response.should have_tag("form[action=?][method=post]", publications_path) do
      with_tag("input#publication_title[name=?]", "publication[title]")
      with_tag("input#publication_image[name=?]", "publication[image]")
      with_tag("input#publication_board[name=?]", "publication[board]")
    end
  end
end
