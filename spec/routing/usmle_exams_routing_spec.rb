require "rails_helper"

RSpec.describe UsmleExamsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/usmle_exams").to route_to("usmle_exams#index")
    end

    it "routes to #new" do
      expect(:get => "/usmle_exams/new").to route_to("usmle_exams#new")
    end

    it "routes to #show" do
      expect(:get => "/usmle_exams/1").to route_to("usmle_exams#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/usmle_exams/1/edit").to route_to("usmle_exams#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/usmle_exams").to route_to("usmle_exams#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/usmle_exams/1").to route_to("usmle_exams#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/usmle_exams/1").to route_to("usmle_exams#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/usmle_exams/1").to route_to("usmle_exams#destroy", :id => "1")
    end
  end
end
