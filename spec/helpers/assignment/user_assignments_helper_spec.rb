require "spec_helper"

describe Assignment::UserAssignmentsHelper do

  describe "#hf_label_color" do
    it "should return an empty string if ur.ua has empty status_hash" do
      expect(hf_label_color((create :user_response), :status)).to eq ""
      expect(hf_label_color((create :user_response), :owner_status)).to eq ""
    end
  end
end
