require 'spec_helper'

describe "/galleries/index.html.erb" do
  include GalleriesHelper

  before(:each) do
    assigns[:galleries] = [
      stub_model(Gallery, :title => 'asdf'),
      stub_model(Gallery, :title => 'asdf')
    ]
    assigns[:offset] = 0
  end

  it "renders a list of galleries" do
    render
  end
end
