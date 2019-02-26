require "rails_helper"

RSpec.describe ArtifactsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/artifacts").to route_to("artifacts#index")
    end

    it "routes to #new" do
      expect(:get => "/artifacts/new").to route_to("artifacts#new")
    end

    it "routes to #show" do
      expect(:get => "/artifacts/1").to route_to("artifacts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/artifacts/1/edit").to route_to("artifacts#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/artifacts").to route_to("artifacts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/artifacts/1").to route_to("artifacts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/artifacts/1").to route_to("artifacts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/artifacts/1").to route_to("artifacts#destroy", :id => "1")
    end
  end
end
