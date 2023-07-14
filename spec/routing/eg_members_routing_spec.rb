require "rails_helper"

RSpec.describe EgMembersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/eg_members").to route_to("eg_members#index")
    end

    it "routes to #new" do
      expect(get: "/eg_members/new").to route_to("eg_members#new")
    end

    it "routes to #show" do
      expect(get: "/eg_members/1").to route_to("eg_members#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/eg_members/1/edit").to route_to("eg_members#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/eg_members").to route_to("eg_members#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/eg_members/1").to route_to("eg_members#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/eg_members/1").to route_to("eg_members#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/eg_members/1").to route_to("eg_members#destroy", id: "1")
    end
  end
end
