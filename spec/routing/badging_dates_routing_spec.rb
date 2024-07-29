require "rails_helper"

RSpec.describe BadgingDatesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/badging_dates").to route_to("badging_dates#index")
    end

    it "routes to #new" do
      expect(get: "/badging_dates/new").to route_to("badging_dates#new")
    end

    it "routes to #show" do
      expect(get: "/badging_dates/1").to route_to("badging_dates#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/badging_dates/1/edit").to route_to("badging_dates#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/badging_dates").to route_to("badging_dates#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/badging_dates/1").to route_to("badging_dates#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/badging_dates/1").to route_to("badging_dates#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/badging_dates/1").to route_to("badging_dates#destroy", id: "1")
    end
  end
end
