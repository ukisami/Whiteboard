require 'spec_helper'

describe "/comments/show.html.erb" do
  include CommentsHelper
  before(:each) do
    assigns[:comment] = @comment = stub_model(Comment,
      :content => "value for content",
      :publication => 1,
      :comment_id => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ content/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end
