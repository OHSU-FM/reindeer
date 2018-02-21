require 'rails_helper'

RSpec.describe Coaching::StudentsController, type: :controller do

  context "as student" do
    let(:student) { create :student }
    before(:each) do; login_user student; end

    describe "GET #show" do
      before(:each) do
        get :show, params: { slug: student.to_param }
      end

      it "is successful" do
        expect(response).to be_success
      end

      it "assigns @student to the current_user" do
        expect(assigns[:student]).to eq student
      end

      it "assigns @goals to current_user.goals" do
        expect(assigns[:goals]).to eq student.goals
      end

      it "assigns @meetings to current_user.meetings" do
        expect(assigns[:meetings]).to eq student.meetings
      end

      it "doesn't assign @cohorts" do
        expect(assigns[:cohorts]).to eq nil
      end

      it "doesn't assign @students" do
        expect(assigns[:students]).to eq nil
      end
    end
  end

  context "as a coach" do
    let(:coach) { create :coach }
    let(:first_student) { coach.cohorts.first.users.first }
    before(:each) do; login_user coach; end

    describe "GET #show" do
      before(:each) do
        get :show, params: { slug: first_student.to_param }
      end

      it "is successful" do
        expect(response).to be_success
      end

      it "assigns @student to the first_student" do
        expect(assigns[:student]).to eq first_student
      end

      it "assigns @goals to first_student.goals" do
        expect(assigns[:goals]).to eq first_student.goals
      end

      it "assigns @meetings to first_student.meetings" do
        expect(assigns[:meetings]).to eq first_student.meetings
      end

      it "assigns the coach's cohorts to @cohorts" do
        expect(assigns[:cohorts]).to eq coach.cohorts
      end

      it "assigns the students in the first cohort to @students" do
        expect(assigns[:students]).to eq coach.cohorts.first.users
      end
    end
  end
end
