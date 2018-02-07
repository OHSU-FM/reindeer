require "rails_helper"

RSpec.describe Coaching::StudentsController, type: :routing do
  describe "routing" do

    it "doesn't route to #index" do
      expect(:get => "/coaching/students").not_to route_to("coaching/students#index")
    end

    it "routes to #new" do
      expect(:get => "/coaching/students/new").to route_to("coaching/students#new")
    end

    it "routes to #show" do
      expect(:get => "/coaching/students/email").to route_to("coaching/students#show", :slug => "email")
    end

    it "routes to #edit" do
      expect(:get => "/coaching/students/email/edit").to route_to("coaching/students#edit", :slug => "email")
    end

    it "routes to #create" do
      expect(:post => "/coaching/students").to route_to("coaching/students#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/coaching/students/email").to route_to("coaching/students#update", :slug => "email")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/coaching/students/email").to route_to("coaching/students#update", :slug => "email")
    end

    it "routes to #destroy" do
      expect(:delete => "/coaching/students/email").to route_to("coaching/students#destroy", :slug => "email")
    end

  end
end
