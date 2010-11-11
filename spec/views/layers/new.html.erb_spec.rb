require 'spec_helper'

describe "/layers/new.html.erb" do
  include LayersHelper

  before(:each) do
    assigns[:layer] = @layer = Layer.new
    #@layer.stub(:id).and_return(8)
  end

  it "renders new layer form" do
    render

    response.should have_tag("form[action=?][method=post]", layers_path) do
    end
  end
end
