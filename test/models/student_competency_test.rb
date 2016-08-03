require "test_helper"

describe StudentCompetency do
  let(:student_competency) { StudentCompetency.new }

  it "must be valid" do
    value(student_competency).must_be :valid?
  end
end
