require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/course_schedules", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # CourseSchedule. As you add validations to CourseSchedule, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      CourseSchedule.create! valid_attributes
      get course_schedules_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      course_schedule = CourseSchedule.create! valid_attributes
      get course_schedule_url(course_schedule)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_course_schedule_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      course_schedule = CourseSchedule.create! valid_attributes
      get edit_course_schedule_url(course_schedule)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new CourseSchedule" do
        expect {
          post course_schedules_url, params: { course_schedule: valid_attributes }
        }.to change(CourseSchedule, :count).by(1)
      end

      it "redirects to the created course_schedule" do
        post course_schedules_url, params: { course_schedule: valid_attributes }
        expect(response).to redirect_to(course_schedule_url(CourseSchedule.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new CourseSchedule" do
        expect {
          post course_schedules_url, params: { course_schedule: invalid_attributes }
        }.to change(CourseSchedule, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post course_schedules_url, params: { course_schedule: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested course_schedule" do
        course_schedule = CourseSchedule.create! valid_attributes
        patch course_schedule_url(course_schedule), params: { course_schedule: new_attributes }
        course_schedule.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the course_schedule" do
        course_schedule = CourseSchedule.create! valid_attributes
        patch course_schedule_url(course_schedule), params: { course_schedule: new_attributes }
        course_schedule.reload
        expect(response).to redirect_to(course_schedule_url(course_schedule))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        course_schedule = CourseSchedule.create! valid_attributes
        patch course_schedule_url(course_schedule), params: { course_schedule: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested course_schedule" do
      course_schedule = CourseSchedule.create! valid_attributes
      expect {
        delete course_schedule_url(course_schedule)
      }.to change(CourseSchedule, :count).by(-1)
    end

    it "redirects to the course_schedules list" do
      course_schedule = CourseSchedule.create! valid_attributes
      delete course_schedule_url(course_schedule)
      expect(response).to redirect_to(course_schedules_url)
    end
  end
end
