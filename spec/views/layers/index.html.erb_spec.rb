require 'spec_helper'

describe "/layers/index.html.erb" do
  include LayersHelper

  before(:each) do
    assigns[:layers] = [
      stub_model(Layer),
      stub_model(Layer)
    ]
  end

  it "renders a list of layers" do
    render
  end
end
