require 'spec_helper'

describe "/comments/edit.html.erb" do
  include CommentsHelper

  before(:each) do
    assigns[:comment] = @comment = stub_model(Comment,
      :new_record? => false,
      :content => "value for content",
      :publication => 1,
      :comment_id => 1
    )
  end

  it "renders the edit comment form" do
    render

    response.should have_tag("form[action=#{comment_path(@comment)}][method=post]") do
      with_tag('input#comment_content[name=?]', "comment[content]")
      with_tag('input#comment_publication[name=?]', "comment[publication]")
      with_tag('input#comment_comment_id[name=?]', "comment[comment_id]")
    end
  end
end
