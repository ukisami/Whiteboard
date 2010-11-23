require 'spec_helper'

describe "/galleries/show.html.erb" do
  include GalleriesHelper
  before(:each) do
    assigns[:gallery] = @gallery = stub_model(Gallery, :title => 'asdf')
  end

  it "renders attributes in <p>" do
    render
  end
end
