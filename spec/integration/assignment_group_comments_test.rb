require "rails_helper"

class CanCommentOnAssignmentGroups < Capybara::Rails::TestCase
  def test_user_can_comment_on_assignment_groups_they_own
    user = FactoryGirl.create(:coach)
    sign_in user
    visit assignment_assignment_groups_path
    binding.pry
    click_link('Comment')
  end
end
