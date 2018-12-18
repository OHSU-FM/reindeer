require "rails_helper"

RSpec.describe EpasController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/epas").to route_to("epas#index")
    end

    it "routes to #new" do
      expect(:get => "/epas/new").to route_to("epas#new")
    end

    it "routes to #show" do
      expect(:get => "/epas/1").to route_to("epas#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/epas/1/edit").to route_to("epas#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/epas").to route_to("epas#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/epas/1").to route_to("epas#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/epas/1").to route_to("epas#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/epas/1").to route_to("epas#destroy", :id => "1")
    end
  end
end
