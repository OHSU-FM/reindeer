require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe "assignment_group" do
    let(:ag) { create :assignment_group, :with_users, owner: user }

    describe "coach" do
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

    describe "participant" do
      let(:coach) { create :coach }
      let(:ag) { create :assignment_group, :with_users, owner: coach }
      let(:user) { User.find(ag.user_ids.first) }

      describe "actions" do
        it { is_expected.to be_able_to(:list, ag) }
        it { is_expected.to be_able_to(:read, ag) }
        it { is_expected.not_to be_able_to(:comment_on, ag)}
        it { is_expected.not_to be_able_to(:alter, ag)}
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

    describe "coach" do
      let(:user) { create :coach }
      let(:ag) { create :assignment_group, :with_full_template, owner: user }
      let(:sa) { create :survey_assignment, :with_user_assignment, assignment_group: ag }
      let(:ua) { sa.user_assignments.first }

      describe "actions" do
        it { is_expected.not_to be_able_to(:alter, ua) }
        it { is_expected.to be_able_to(:list, ua) }
        it { is_expected.to be_able_to(:read, ua) }
      end
    end

    describe "participant" do
      let(:coach) { create :coach }
      let(:ag) { create :assignment_group, :with_users, :with_full_template, owner: coach }
      let(:sa) { create :survey_assignment, assignment_group: ag }
      let(:user) { User.find(ag.user_ids.first) }
      let(:ua) { create :user_assignment, survey_assignment: sa, user: user }

      describe "actions" do
        it { is_expected.not_to be_able_to(:alter, ua) }
        it { is_expected.to be_able_to(:list, ua) }
        it { is_expected.to be_able_to(:read, ua) }
      end
    end
  end

  describe "user_response" do

    describe "coach" do
      let(:user) { create :coach }
      let(:ag) { create :assignment_group, :with_full_template, owner: user }
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

    describe "participant" do
      let(:coach) { create :coach }
      let(:ag) { create :assignment_group, :with_users, :with_full_template, owner: coach }
      let(:sa) { create :survey_assignment, assignment_group: ag }
      let(:user) { User.find(ag.user_ids.first) }
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
end
