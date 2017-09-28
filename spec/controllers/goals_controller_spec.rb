require 'spec_helper'

RSpec.describe GoalsController, type: :controller do
  describe 'GET #index' do
    context 'as admin user' do
      let(:user) { create :admin }
      before :each do
        sign_in user
      end

      it 'sets @cohorts to Cohorts.all' do
        get :index
        expect(assigns[:cohorts]).to eq Cohort.all
      end

      # it 'sets @goals to @cohorts.first.users.first.goals' do
      #   get :index
      #   expect(assigns[:goals]).to eq Cohort.first.users.first.goals
      # end
    end
  end
end
