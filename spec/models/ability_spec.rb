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
