require "rails_helper"

describe Assignment::AssignmentGroup do

  it "has a valid factory" do
    create :assignment_group, :with_template
  end

end
