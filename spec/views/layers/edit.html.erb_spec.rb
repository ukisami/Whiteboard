require 'spec_helper'

describe "/layers/edit.html.erb" do
  include LayersHelper

  before(:each) do
    assigns[:layer] = @layer = stub_model(Layer,
      :new_record? => false
    )
  end

  it "renders the edit layer form" do
    render

    response.should have_tag("form[action=#{layer_path(@layer)}][method=post]") do
    end
  end
end
