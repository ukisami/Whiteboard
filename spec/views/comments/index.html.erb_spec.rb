require 'spec_helper'

describe "/comments/index.html.erb" do
  include CommentsHelper

  before(:each) do
    assigns[:comments] = [
      stub_model(Comment,
        :content => "value for content",
        :publication => 1,
        :comment_id => 1
      ),
      stub_model(Comment,
        :content => "value for content",
        :publication => 1,
        :comment_id => 1
      )
    ]
  end

  it "renders a list of comments" do
    render
    response.should have_tag("tr>td", "value for content".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
