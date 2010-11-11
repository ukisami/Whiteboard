require 'spec_helper'

describe "/publications/edit.html.erb" do
  include PublicationsHelper

  before(:each) do
    assigns[:publication] = @publication = stub_model(Publication,
      :new_record? => false,
      :title => "value for title",
      :image => "value for image",
      :board => 1
    )
  end

  it "renders the edit publication form" do
    render

    response.should have_tag("form[action=#{publication_path(@publication)}][method=post]") do
      with_tag('input#publication_title[name=?]', "publication[title]")
      with_tag('input#publication_image[name=?]', "publication[image]")
      with_tag('input#publication_board[name=?]', "publication[board]")
    end
  end
end
