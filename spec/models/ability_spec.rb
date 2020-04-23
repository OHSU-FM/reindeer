require "spec_helper"
require "cancan/matchers"

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe "User" do
    let(:user) { create :user }

    describe "actions" do
      it { is_expected.to be_able_to(:update, user) }
      it { is_expected.to be_able_to(:read, user) }
      it { is_expected.not_to be_able_to(:create, user) }
      it { is_expected.not_to be_able_to(:destroy, user) }
    end
  end

  describe "Dashboard" do

    context "logged in user" do
      let(:user) { create :user, :with_dashboard }

      describe "actions" do
        let(:dash) { user.dashboard }

        it { is_expected.to be_able_to(:crud, dash) }
      end
    end
  end

  describe "coaching system" do
    context "as a student" do
      let(:user) { create :student }
      let(:goal) { create :goal, user: user }
      let(:meeting) { create :meeting, user: user }
      let(:another_users_goal) { create :goal }
      let(:another_users_meeting) { create :meeting }

      describe "own goals" do
        it { is_expected.to be_able_to(:create, Coaching::Goal) }
        it { is_expected.to be_able_to(:read, goal) }
        it { is_expected.to be_able_to(:update, goal) }

        it { is_expected.to be_able_to(:create, Coaching::Meeting) }
        it { is_expected.to be_able_to(:read, meeting) }
        it { is_expected.to be_able_to(:update, meeting) }

        it { is_expected.not_to be_able_to(:destroy, goal) }
        it { is_expected.not_to be_able_to(:read, another_users_goal) }
        it { is_expected.not_to be_able_to(:update, another_users_goal) }
        it { is_expected.not_to be_able_to(:destroy, another_users_goal) }

        it { is_expected.not_to be_able_to(:destroy, meeting) }
        it { is_expected.not_to be_able_to(:read, another_users_meeting) }
        it { is_expected.not_to be_able_to(:update,another_users_meeting) }
        it { is_expected.not_to be_able_to(:destroy,another_users_meeting) }
      end
    end

    context "as a coach" do
      let(:user) { create :coach }
      let(:cohort) { create(:cohort, :with_users, owner: user) }
      let(:student) { cohort.users.first }
      let(:goal) { create :goal, user: student }
      let(:meeting) { create :meeting, user: student }
      let(:another_users_goal) { create :goal }
      let(:another_users_meeting) { create :meeting }

      describe "students' goals" do
        it { is_expected.to be_able_to(:create, Coaching::Goal) }
        it { is_expected.to be_able_to(:read, goal) }
        it { is_expected.to be_able_to(:update, goal) }

        it { is_expected.not_to be_able_to(:destroy, goal) }
        it { is_expected.not_to be_able_to(:read, another_users_goal) }
        it { is_expected.not_to be_able_to(:update, another_users_goal) }
        it { is_expected.not_to be_able_to(:destroy, another_users_goal) }
      end

      describe "students' meetings" do
        it { is_expected.to be_able_to(:create, Coaching::Meeting) }
        it { is_expected.to be_able_to(:read, meeting) }
        it { is_expected.to be_able_to(:update, meeting) }

        it { is_expected.not_to be_able_to(:destroy, meeting) }
        it { is_expected.not_to be_able_to(:read, another_users_meeting) }
        it { is_expected.not_to be_able_to(:update, another_users_meeting) }
        it { is_expected.not_to be_able_to(:destroy, another_users_meeting) }
      end
    end

    context "as a dean" do
      let(:user) { create :user, coaching_type: 'dean' }
      let(:goal) { create :goal, user: user }
      let(:meeting) { create :meeting, user: user }
      let(:another_users_goal) { create :goal }
      let(:another_users_meeting) { create :meeting }

      describe "any goals" do
        it { is_expected.to be_able_to(:read, goal) }
        it { is_expected.to be_able_to(:read, another_users_goal) }

        it { is_expected.to be_able_to(:read, meeting) }
        it { is_expected.to be_able_to(:read, another_users_meeting) }

        it { is_expected.not_to be_able_to(:create, Coaching::Goal) }
        it { is_expected.not_to be_able_to(:create, Coaching::Meeting) }
        it { is_expected.not_to be_able_to(:update, goal) }
        it { is_expected.not_to be_able_to(:destroy, goal) }
        it { is_expected.not_to be_able_to(:update, another_users_goal) }
        it { is_expected.not_to be_able_to(:update, meeting) }
        it { is_expected.not_to be_able_to(:destroy, meeting) }
        it { is_expected.not_to be_able_to(:update, another_users_meeting) }
      end
    end
  end
end
