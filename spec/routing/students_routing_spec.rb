require "rails_helper"

RSpec.describe Coaching::StudentsController, type: :routing do
  describe "routing" do

    it "routes to #show" do
      expect(:get => "/coaching/students/email").to route_to("coaching/students#show", :slug => "email")
    end

    it "routes to #search_goals via POST" do
      expect(:post => "/coaching/students/email/search_goals")
        .to route_to("coaching/students#search_goals", :slug => "email")
    end

    it "routes to #completed_goals via POST" do
      expect(:post => "/coaching/students/email/completed_goals")
        .to route_to("coaching/students#completed_goals", :slug => "email")
    end

    it "routes to #search_meetings via POST" do
      expect(:post => "/coaching/students/email/search_meetings")
        .to route_to("coaching/students#search_meetings", :slug => "email")
    end
  end
end
