require "spec_helper"

describe Assignment::UserAssignmentsHelper do

  describe "#hf_status_label_color" do
    it "should return an empty string if ur.ua has empty status_hash" do
      expect(hf_status_label_color(create :user_response)).to eq ""
    end
  end
end
