require 'rails_helper'

RSpec.describe Coaching::MeetingsController, type: :controller do

  describe "DELETE #destroy" do
    context "when admin is signed in" do
      let!(:meeting) { create :meeting }

      before :each do
        admin = create :admin
        login_user admin
      end

      it "deletes the meeting" do
        expect {
          delete :destroy, xhr: true, params: { id: meeting.id }
        }.to change(Coaching::Meeting, :count).by(-1)
      end
    end

    context "when coach is signed in" do
      let!(:meeting) { create :meeting }

      before :each do
        coach = create :coach
        login_user coach
      end

      it "doesn't delete the meeting" do
        expect {
          delete :destroy, xhr: true, params: { id: meeting.id }
        }.to change(Coaching::Meeting, :count).by(0)
      end
    end

    context "when student is signed in" do
      let!(:meeting) { create :meeting }

      before :each do
        student = create :student
        login_user student
      end

      it "doesn't delete the meeting" do
        expect {
          delete :destroy, xhr: true, params: { id: meeting.id }
        }.to change(Coaching::Meeting, :count).by(0)
      end
    end
  end
end
