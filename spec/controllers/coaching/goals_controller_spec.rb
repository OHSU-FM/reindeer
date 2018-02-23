require 'rails_helper'

RSpec.describe Coaching::GoalsController, type: :controller do

  describe "PUT #update" do
    context "without session" do
      let!(:goal) { create :goal }

      it "is unauthorized" do
        put :update, xhr: true, params: { id: goal.id }
        expect(response).to be_unauthorized
      end
    end

    context "with session" do
      let(:student) { create :student }
      let(:goal) { create :goal, user: student }

      before :each do
        login_user student
      end

      context "invalid params" do
        let(:params) { goal.attributes.merge("status" => "some_value") }

        it "doesn't update the status" do
          put :update, xhr: true, params: params
          expect(goal.status).to eq "Not Started"
        end

        it "responds with 422" do
          put :update, xhr: true, params: params
          expect(response.status).to eq 422
        end
      end

      context "valid params" do
        let(:params) { { id: goal.to_param, status: "On Track" } }

        it "is successful" do
          put :update, xhr: true, params: params
          expect(response).to be_successful
        end

        fit "updates the status" do
          put :update, xhr: true, params: params
          goal.reload
          expect(goal.status).to eq "On Track"
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "when admin is signed in" do
      let!(:goal) { create :goal }

      before :each do
        admin = create :admin
        login_user admin
      end

      it "deletes the goal" do
        expect {
          delete :destroy, xhr: true, params: { id: goal.id }
        }.to change(Coaching::Goal, :count).by(-1)
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
          delete :destroy, xhr: true, params: { id: goal.id }
        }.to change(Coaching::Goal, :count).by(0)
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
          delete :destroy, xhr: true, params: { id: goal.id }
        }.to change(Coaching::Goal, :count).by(0)
      end
    end
  end
end
