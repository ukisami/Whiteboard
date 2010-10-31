require 'spec_helper'

describe BoardsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/boards" }.should route_to(:controller => "boards", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/boards/new" }.should route_to(:controller => "boards", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/boards/1" }.should route_to(:controller => "boards", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/boards/1/edit" }.should route_to(:controller => "boards", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/boards" }.should route_to(:controller => "boards", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/boards/1" }.should route_to(:controller => "boards", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/boards/1" }.should route_to(:controller => "boards", :action => "destroy", :id => "1") 
    end
  end
end
