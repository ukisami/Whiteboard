require 'spec_helper'

describe "/publications/index.html.erb" do
  include PublicationsHelper

  before(:each) do
    assigns[:publications] = [
      stub_model(Publication,
        :title => "value for title",
        :image => "value for image",
        :board => 1
      ),
      stub_model(Publication,
        :title => "value for title",
        :image => "value for image",
        :board => 1
      )
    ]
  end

  it "renders a list of publications" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for image".to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end
