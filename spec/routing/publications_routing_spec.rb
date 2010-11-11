require 'spec_helper'

describe PublicationsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/publications" }.should route_to(:controller => "publications", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/publications/new" }.should route_to(:controller => "publications", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/publications/1" }.should route_to(:controller => "publications", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/publications/1/edit" }.should route_to(:controller => "publications", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/publications" }.should route_to(:controller => "publications", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/publications/1" }.should route_to(:controller => "publications", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/publications/1" }.should route_to(:controller => "publications", :action => "destroy", :id => "1") 
    end
  end
end
