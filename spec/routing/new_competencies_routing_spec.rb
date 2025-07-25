require "rails_helper"

RSpec.describe NewCompetenciesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/new_competencies").to route_to("new_competencies#index")
    end

    it "routes to #new" do
      expect(get: "/new_competencies/new").to route_to("new_competencies#new")
    end

    it "routes to #show" do
      expect(get: "/new_competencies/1").to route_to("new_competencies#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/new_competencies/1/edit").to route_to("new_competencies#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/new_competencies").to route_to("new_competencies#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/new_competencies/1").to route_to("new_competencies#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/new_competencies/1").to route_to("new_competencies#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/new_competencies/1").to route_to("new_competencies#destroy", id: "1")
    end
  end
end
