require "rails_helper"

RSpec.describe CourseSchedulesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/course_schedules").to route_to("course_schedules#index")
    end

    it "routes to #new" do
      expect(get: "/course_schedules/new").to route_to("course_schedules#new")
    end

    it "routes to #show" do
      expect(get: "/course_schedules/1").to route_to("course_schedules#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/course_schedules/1/edit").to route_to("course_schedules#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/course_schedules").to route_to("course_schedules#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/course_schedules/1").to route_to("course_schedules#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/course_schedules/1").to route_to("course_schedules#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/course_schedules/1").to route_to("course_schedules#destroy", id: "1")
    end
  end
end
