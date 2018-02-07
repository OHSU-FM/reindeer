require 'rails_helper'

RSpec.describe Coaching::StudentsHelper, type: :helper do
  it '#hf_active_cohort? returns true if the student is in the cohort' do
    s = create :student
    c = create :cohort, users: [s]
    other_user = create :user
    expect(helper.hf_active_cohort?(c, s)).to be_truthy
    expect(helper.hf_active_cohort?(c, other_user)).to be_falsey
  end
end
