require 'spec_helper'

describe GalleriesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/galleries" }.should route_to(:controller => "galleries", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/galleries/new" }.should route_to(:controller => "galleries", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/galleries/1" }.should route_to(:controller => "galleries", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/galleries/1/edit" }.should route_to(:controller => "galleries", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/galleries" }.should route_to(:controller => "galleries", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/galleries/1" }.should route_to(:controller => "galleries", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/galleries/1" }.should route_to(:controller => "galleries", :action => "destroy", :id => "1") 
    end
  end
end
