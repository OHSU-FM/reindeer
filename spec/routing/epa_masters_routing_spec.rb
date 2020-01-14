require "rails_helper"

RSpec.describe EpaMastersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/epa_masters").to route_to("epa_masters#index")
    end

    it "routes to #new" do
      expect(:get => "/epa_masters/new").to route_to("epa_masters#new")
    end

    it "routes to #show" do
      expect(:get => "/epa_masters/1").to route_to("epa_masters#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/epa_masters/1/edit").to route_to("epa_masters#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/epa_masters").to route_to("epa_masters#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/epa_masters/1").to route_to("epa_masters#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/epa_masters/1").to route_to("epa_masters#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/epa_masters/1").to route_to("epa_masters#destroy", :id => "1")
    end
  end
end
