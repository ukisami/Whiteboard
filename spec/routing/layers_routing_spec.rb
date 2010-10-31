require 'spec_helper'

describe LayersController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/layers" }.should route_to(:controller => "layers", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/layers/new" }.should route_to(:controller => "layers", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/layers/1" }.should route_to(:controller => "layers", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/layers/1/edit" }.should route_to(:controller => "layers", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/layers" }.should route_to(:controller => "layers", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/layers/1" }.should route_to(:controller => "layers", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/layers/1" }.should route_to(:controller => "layers", :action => "destroy", :id => "1") 
    end
  end
end
