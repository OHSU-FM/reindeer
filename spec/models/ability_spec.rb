require 'spec_helper'
require 'cancan/matchers'

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

  describe "AssignmentGroupTemplate" do
    let(:agt) { create :assignment_group_template }

    context "coach user" do
      # !exist views for agt
      let(:user) { create :coach }

      describe "actions" do
        it { is_expected.not_to be_able_to(:crud, agt) }
      end
    end

    context "participant user" do
      # !exist views for agt
      let(:user) { create :student }

      describe "actions" do
        it { is_expected.not_to be_able_to(:crud, agt) }
      end
    end
  end

  describe "AssignmentGroup" do
    let(:ag) { create :assignment_group, :with_full_template,
               cohort: create(:cohort, :with_users, owner: user )}

    context "coach user" do
      let(:user) { create :coach }

      describe "actions" do
        it { is_expected.to be_able_to(:list, ag) }
        it { is_expected.to be_able_to(:read, ag) }
        it { is_expected.to be_able_to(:comment_on, ag) }
        it { is_expected.not_to be_able_to(:alter, ag)}
      end

      describe "comments" do
        let(:comment) { create :comment, commentable: ag, user: user }
        let(:other_comment) { create :comment, commentable: ag, user: create(:user) }

        it { is_expected.to be_able_to(:read, comment) }
        it { is_expected.to be_able_to(:read, other_comment) }
        it { is_expected.to be_able_to(:create, Comment.new(commentable: ag)) }
        it { is_expected.to be_able_to(:destroy, comment) }
        it { is_expected.not_to be_able_to(:destroy, other_comment) }
      end
    end

    context "participant user" do
      let(:coach) { create :coach }
      let(:ag) { create :assignment_group, :with_full_template,
                 cohort: create(:cohort, :with_users, owner: coach )}
      let(:user) { ag.users.first }

      describe "actions" do
        it { is_expected.to be_able_to(:list, ag) }
        it { is_expected.to be_able_to(:read, ag) }
        it { is_expected.not_to be_able_to(:comment_on, ag) }
        it { is_expected.not_to be_able_to(:alter, ag) }
      end

      describe "comments" do
        let(:comment) { create :comment, commentable: ag, user: coach }

        it { is_expected.to be_able_to(:read, comment) }
        it { is_expected.not_to be_able_to(:create, Comment.new(commentable: ag)) }
        it { is_expected.not_to be_able_to(:destroy, comment) }
      end
    end
  end

  describe "user_assignment" do

    context "coach user" do
      let(:user) { create :coach }
      let(:ag) { create :assignment_group, :with_full_template,
                 cohort: create(:cohort, owner: user )}
      let(:sa) { create :survey_assignment, :with_user_assignment, assignment_group: ag }
      let(:ua) { sa.user_assignments.first }

      describe "actions" do
        it { is_expected.not_to be_able_to(:alter, ua) }
        it { is_expected.to be_able_to(:list, ua) }
        it { is_expected.to be_able_to(:read, ua) }
        it { is_expected.to be_able_to(:fetch_compare, ua) }
      end
    end

    context "participant user" do
      let(:coach) { create :coach }
      let(:cohort) { create :cohort, :with_users, owner: coach}
      let(:ag) { create :assignment_group, :with_full_template,
                 cohort: cohort }
      let(:sa) { create :survey_assignment, assignment_group: ag }
      let(:user) { ag.users.first }
      let(:ua) { create :user_assignment, survey_assignment: sa, user: user }

      describe "actions" do
        it { is_expected.not_to be_able_to(:alter, ua) }
        it { is_expected.to be_able_to(:list, ua) }
        it { is_expected.to be_able_to(:read, ua) }
        it { is_expected.to be_able_to(:fetch_compare, ua) }
      end
    end
  end

  describe "UserResponse" do

    context "coach user" do
      let(:user) { create :coach }
      let(:ag) { create :assignment_group, :with_full_template,
               cohort: create(:cohort, :with_users, owner: user )}
      let(:sa) { create :survey_assignment, :with_user_assignment, assignment_group: ag }
      let(:participant) { sa.user_assignments.first.user }
      let(:ur) { create :user_response, user_assignment: sa.user_assignments.first }

      describe "actions" do
        it { is_expected.to be_able_to(:comment_on, ur) }
        it { is_expected.to be_able_to(:list, ur) }
        it { is_expected.to be_able_to(:read, ur) }
        it { is_expected.not_to be_able_to(:alter, ur) }
      end

      describe "comments" do
        let(:comment) { create :comment, commentable: ur, user: user }
        let(:other_comment) { create :comment, commentable: ur, user: participant }

        it { is_expected.to be_able_to(:read, comment) }
        it { is_expected.to be_able_to(:read, other_comment) }
        it { is_expected.to be_able_to(:create, Comment.new(commentable: ur)) }
        it { is_expected.to be_able_to(:destroy, comment) }
        it { is_expected.not_to be_able_to(:destroy, other_comment) }
      end
    end

    context "participant user" do
      let(:coach) { create :coach }
      let(:ag) { create :assignment_group, :with_full_template,
               cohort: create(:cohort, :with_users, owner: coach )}
      let(:sa) { create :survey_assignment, assignment_group: ag }
      let(:user) { ag.users.first }
      let(:ua) { create :user_assignment, survey_assignment: sa, user: user }
      let(:ur) { create :user_response, user_assignment: ua }

      describe "actions" do
        it { is_expected.to be_able_to(:comment_on, ur) }
        it { is_expected.to be_able_to(:list, ur) }
        it { is_expected.to be_able_to(:read, ur) }
        it { is_expected.not_to be_able_to(:alter, ur) }
      end

      describe "comments" do
        let(:comment) { create :comment, commentable: ur, user: user }
        let(:other_comment) { create :comment, commentable: ur, user: coach }

        it { is_expected.to be_able_to(:read, comment) }
        it { is_expected.to be_able_to(:read, other_comment) }
        it { is_expected.to be_able_to(:create, Comment.new(commentable: ur)) }
        it { is_expected.to be_able_to(:destroy, comment) }
        it { is_expected.not_to be_able_to(:destroy, other_comment) }
      end
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
end
