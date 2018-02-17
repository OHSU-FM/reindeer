require 'rails_helper'

RSpec.describe Coaching::GoalsController, type: :controller do

  describe "DELETE #destroy" do
    context "when admin is signed in" do
      let!(:goal) { create :goal }

      before :each do
        admin = create :admin
        login_user admin
      end

      it "deletes the goal" do
        expect {
          delete :destroy, params: { id: goal.id }
        }.to change(Goal, :count).by(-1)
      end
    end

    context "when coach is signed in" do
      let!(:goal) { create :goal }

      before :each do
        coach = create :coach
        login_user coach
      end

      it "doesn't delete the goal" do
        expect {
          delete :destroy, params: { id: goal.id }
        }.to change(Goal, :count).by(0)
      end
    end

    context "when student is signed in" do
      let!(:goal) { create :goal }

      before :each do
        student = create :student
        login_user student
      end

      it "doesn't delete the goal" do
        expect {
          delete :destroy, params: { id: goal.id }
        }.to change(Goal, :count).by(0)
      end
    end
  end
end
