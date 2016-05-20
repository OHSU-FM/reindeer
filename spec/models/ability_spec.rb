require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe "coach" do
    let(:user) { create :coach }

    describe "assignment_group" do
      let(:ag) { create :assignment_group, owner: user }

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

    describe "user_response" do
      let(:sa) { create :survey_assignment, :with_user_assignments }
      let(:participant) { sa.user_assignments.first.user }
      let(:ur) { create :user_response, user_assignment: sa.user_assignments.first }

      it { binding.pry }
      describe "comments" do
        let(:comment) { create :comment, commentable: ur, user: user }
        let(:other_comment) { create :comment, commentable: ur, user: student }

        it { is_expected.to be_able_to(:read, comment) }
        it { is_expected.to be_able_to(:read, other_comment) }
        it { is_expected.to be_able_to(:create, Comment.new(commentable: ur)) }
        it { is_expected.to be_able_to(:destroy, comment) }
        it { is_expected.not_to be_able_to(:destroy, other_comment) }
      end
    end
  end
end
