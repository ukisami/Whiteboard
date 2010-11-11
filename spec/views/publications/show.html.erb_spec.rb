require 'spec_helper'

describe "/publications/show.html.erb" do
  include PublicationsHelper
  before(:each) do
    assigns[:publication] = @publication = stub_model(Publication,
      :title => "value for title",
      :image => "value for image",
      :board => 1
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ image/)
    response.should have_text(/1/)
  end
end
