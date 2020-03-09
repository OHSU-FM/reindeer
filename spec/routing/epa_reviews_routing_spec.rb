require "rails_helper"

RSpec.describe EpaReviewsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/epa_reviews").to route_to("epa_reviews#index")
    end

    it "routes to #new" do
      expect(:get => "/epa_reviews/new").to route_to("epa_reviews#new")
    end

    it "routes to #show" do
      expect(:get => "/epa_reviews/1").to route_to("epa_reviews#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/epa_reviews/1/edit").to route_to("epa_reviews#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/epa_reviews").to route_to("epa_reviews#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/epa_reviews/1").to route_to("epa_reviews#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/epa_reviews/1").to route_to("epa_reviews#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/epa_reviews/1").to route_to("epa_reviews#destroy", :id => "1")
    end
  end
end
