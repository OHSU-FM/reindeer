require "rails_helper"

RSpec.describe PrecepMeetingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/precep_meetings").to route_to("precep_meetings#index")
    end

    it "routes to #new" do
      expect(get: "/precep_meetings/new").to route_to("precep_meetings#new")
    end

    it "routes to #show" do
      expect(get: "/precep_meetings/1").to route_to("precep_meetings#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/precep_meetings/1/edit").to route_to("precep_meetings#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/precep_meetings").to route_to("precep_meetings#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/precep_meetings/1").to route_to("precep_meetings#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/precep_meetings/1").to route_to("precep_meetings#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/precep_meetings/1").to route_to("precep_meetings#destroy", id: "1")
    end
  end
end
