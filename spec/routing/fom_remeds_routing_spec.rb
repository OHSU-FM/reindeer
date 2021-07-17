require "rails_helper"

RSpec.describe FomRemedsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/fom_remeds").to route_to("fom_remeds#index")
    end

    it "routes to #new" do
      expect(get: "/fom_remeds/new").to route_to("fom_remeds#new")
    end

    it "routes to #show" do
      expect(get: "/fom_remeds/1").to route_to("fom_remeds#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/fom_remeds/1/edit").to route_to("fom_remeds#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/fom_remeds").to route_to("fom_remeds#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/fom_remeds/1").to route_to("fom_remeds#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/fom_remeds/1").to route_to("fom_remeds#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/fom_remeds/1").to route_to("fom_remeds#destroy", id: "1")
    end
  end
end
