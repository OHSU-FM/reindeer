require "spec_helper"

describe Assignment::AssignmentGroupsController do

  let(:admin) { create :superadmin }
  let(:coach) { create :coach }
  let(:student) { create :student }
  let(:agt) { create :assignment_group_template }

  describe "controller actions" do
    describe "#index" do
      context "with signed in user" do
        before do
          user = create :user
          c = create :cohort, :with_users, owner: user
          @ag = create :assignment_group, cohort: c
          sign_in user
          get :index
        end

        it { is_expected.to redirect_to assignment_assignment_group_path(@ag) }
      end
      context "without signed in user" do
        before do
          get :index
        end

        it { is_expected.to redirect_to new_user_session_path }
      end
    end

    describe "#show" do
      context "with signed in owner" do
        before do
          user = create :user
          c = create :cohort, :with_users, owner: user
          @ag = create :assignment_group, cohort: c
          sign_in user
          get :show, assignment_group_id: @ag.id
        end

        it "sets @assignment_group" do
          expect(assigns[:assignment_group]).to eq @ag
        end
        it "sets @assignment_groups" do
          expect(assigns[:assignment_groups]).to eq [@ag]
        end
        it "sets @user" do
          expect(assigns[:user]).to eq @ag.users.first
        end
        it "generates and sets a service object" do
          expect(assigns[:service])
          .to be_an_instance_of Assignment::UserAssignmentsIndexService
        end
      end
      context "with signed in user" do
        before do
          c = create :cohort, :with_users
          user = c.users.first
          @ag = create :assignment_group, cohort: c
          sign_in user
          get :show, assignment_group_id: @ag.id
        end

        it "sets @assignment_group" do
          expect(assigns[:assignment_group]).to eq @ag
        end
        it "sets @assignment_groups" do
          expect(assigns[:assignment_groups]).to eq [@ag]
        end
        it "sets @user" do
          expect(assigns[:user]).to eq @ag.users.first
        end
        it "generates and sets a service object" do
          expect(assigns[:service])
          .to be_an_instance_of Assignment::UserAssignmentsIndexService
        end
      end
      context "without signed in user" do
        before do
          user = create :user
          c = create :cohort, :with_users, owner: user
          @ag = create :assignment_group, cohort: c
          get :show, assignment_group_id: @ag.id
        end
        it { is_expected.to redirect_to new_user_session_path }
      end
    end
  end

  ##############################################################################
  # Public user tests
  ##############################################################################

  describe "not logged in" do
    it "should get redirect" do
      get :index
      expect(response.status).to eq 302
    end
  end

  ##############################################################################
  # admin tests
  ##############################################################################
  describe "admin" do

    #crud
    it "get index should be redirected to assignment group" do
      # redirects to first available assignment_group
      ag = create :assignment_group, :with_users
      sign_in admin

      get :index
      expect(response).to redirect_to(assignment_assignment_group_path(ag))
    end

    it "can update assignment_group" do
      sign_in admin
      ag = create :assignment_group, title: "title", desc_md: "desc"
      put :update, assignment_group_id: ag.id,
        assignment_assignment_group: {
                                   title: "different title",
                                   desc_md: "different desc"
      }
      ag.reload
      expect(ag.title).to eq "different title"
      expect(ag.desc_md).to eq "different desc"
    end
  end

  ##############################################################################
  # coach tests
  ##############################################################################
  describe "coach" do
    it "cannot view admin assignment groups" do
      cohort = create :cohort, owner: admin
      ag = create :assignment_group, cohort: cohort
      sign_in coach
      get :index
      expect(coach.assignment_groups).not_to include(ag)
    end

    # crud
    it "get index should be redirected to assignment group" do
      cohort = create :cohort, owner: coach
      ag = create :assignment_group, cohort: cohort
      sign_in coach

      get :index
      expect(response).to be_success
    end

    it "cannot update assignment_group" do
      sign_in coach
      ag = create :assignment_group, title: "title", desc_md: "desc"
      put :update, assignment_group_id: ag.id,
        assignment_assignment_group: {
                                   title: "different title",
                                   desc_md: "different desc"
      }
      expect(ag).not_to receive(:update_attributes)
      ag.reload
      expect(ag.title).to eq "title"
      expect(ag.desc_md).to eq "desc"
    end
  end

  ##############################################################################
  # student tests
  ##############################################################################
  describe "student" do

    # crud
    it "get index should be redirected to first assignment group" do
      cohort = create :cohort, users: [student]
      sign_in student
      ag = create :assignment_group, cohort: cohort

      get :index
      expect(response).to redirect_to(assignment_assignment_group_path(ag))
    end

    it "cannot update assignment_group" do
      ag = create :assignment_group, title: "title"
      sign_in student

      put :update, assignment_group_id: ag,
        assignment_assignment_group: { title: "a different title" }
      expect(ag.title).to eq "title"
    end
  end
end
