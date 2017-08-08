require 'spec_helper'

RSpec.describe GoalsController, type: :controller do
  describe '#index' do
    before(:each) do
      @u = create :user
      sign_in @u
    end

    it 'assigns the users goals to @goals' do
      get :index
      expect(assigns[:goals]).to eq @u.goals
    end
  end
end
