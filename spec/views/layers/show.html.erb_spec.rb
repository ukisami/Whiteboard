require 'spec_helper'

describe "/layers/show.html.erb" do
  include LayersHelper
  before(:each) do
    assigns[:layer] = @layer = stub_model(Layer)
  end

  it "renders attributes in <p>" do
    render
  end
end
