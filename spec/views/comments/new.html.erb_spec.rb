require 'spec_helper'

describe "/comments/new.html.erb" do
  include CommentsHelper

  before(:each) do
    assigns[:comment] = stub_model(Comment,
      :new_record? => true,
      :content => "value for content",
      :publication => 1,
      :comment_id => 1
    )
  end

  it "renders new comment form" do
    render

    response.should have_tag("form[action=?][method=post]", comments_path) do
      with_tag("input#comment_content[name=?]", "comment[content]")
      with_tag("input#comment_publication[name=?]", "comment[publication]")
      with_tag("input#comment_comment_id[name=?]", "comment[comment_id]")
    end
  end
end
