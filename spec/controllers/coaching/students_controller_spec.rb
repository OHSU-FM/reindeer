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

    describe "POST #search_goals" do
      let(:goal) { create :goal, user: student, name: 'test' }

      it 'assigns @goals to [goal] if term is included in name or desc' do
        post :search_goals, xhr: true, params: { slug: student.to_param, goal_search: 'test' }
        expect(assigns[:goals]).to include goal
      end

      it "doesn't assign @goals to [goal] if term isn't included in name or desc" do
        post :search_goals, xhr: true, params: { slug: student.to_param, goal_search: 'foo' }
        expect(assigns[:goals]).not_to include goal
      end
    end

    describe "POST #search_meetings" do
      let!(:meeting) { create :meeting, user: student, subject: 'test' }

      it 'assigns @meetings to [meeting] if term is included in subject or notes' do
        post :search_meetings, xhr: true, params: { slug: student.to_param, meeting_search: 'test' }
        expect(assigns[:meetings]).to include meeting
      end

      it "doesn't assign @meetings to [meeting] if term isn't included in subject or notes" do
        post :search_meetings, xhr: true, params: { slug: student.to_param, meeting_search: 'foo' }
        expect(assigns[:meetings]).not_to include meeting
      end
    end

    describe "POST #completed_goals" do
      let!(:completed_goal) { create :goal, user: student, g_status: 'Completed', name: "i'm completed!" }
      let!(:uncompleted_goal) { create :goal, user: student, name: "i'm not completed :/" }

      it 'assigns @goals to [completed_goal] if completed_goal is true' do
        post :completed_goals, xhr: true, params: { slug: student.to_param, completed_goal: 'true' }
        expect(assigns[:goals]).to include completed_goal
        expect(assigns[:goals]).not_to include uncompleted_goal
      end

      it "assigns @goals to all the goals if completed_goal is false" do
        post :completed_goals, xhr: true, params: { slug: student.to_param, completed_goal: 'false' }
        expect(assigns[:goals]).to eq student.goals
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
