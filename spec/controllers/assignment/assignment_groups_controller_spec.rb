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

        it { is_expected
             .to redirect_to assignment_assignment_group_path(@ag) }
      end
      context "without signed in user" do
        before do
          user = create :user
          c = create :cohort, :with_users, owner: user
          @ag = create :assignment_group, cohort: c
          get :index
        end
        it { is_expected.to redirect_to new_user_session_path }
      end
    end

    describe "#show" do
      context "with signed in user" do
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
          expect(assigns[:assignment_groups]).to include @ag
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
  describe 'admin' do

    it "can get new assignment_group" do
      sign_in admin
      get :new
      assert_response :success
    end

    #crud
    it "can create assignment_group" do
      sign_in admin
      agt = create :assignment_group_template
      c = create :cohort
      group_params = FactoryGirl.attributes_for(:assignment_group,
                                                assignment_group_template_id: agt.id,
                                                cohort_id: c.id
                                               )

      expect {
        post :create, assignment_assignment_group: group_params
      }.to change(Assignment::AssignmentGroup, :count).by(1)
    end

    it "get index should be redirected to assignment group" do
      # redirects to first available assignment_group
      ag = create :assignment_group, :with_users
      sign_in admin

      get :index
      expect(response).to redirect_to(assignment_assignment_group_path(ag))
    end

    it "can update assignment_group" do
      sign_in admin
      ag = create :assignment_group, title: 'title', desc_md: 'desc'
      put :update, assignment_group_id: ag.id,
        assignment_assignment_group: {
                                   title: 'different title',
                                   desc_md: 'different desc'
      }
      ag.reload
      expect(ag.title).to eq 'different title'
      expect(ag.desc_md).to eq 'different desc'
    end

    it "can delete assignment_group" do
      ag = create :assignment_group
      sign_in admin

      expect {
        delete :destroy, assignment_group_id: ag
      }.to change(Assignment::AssignmentGroup, :count).by(-1)

      expect(subject).to redirect_to(assignment_assignment_groups_path)
    end
  end

  ##############################################################################
  # coach tests
  ##############################################################################
  describe 'coach' do
    it "cannot view admin assignment groups" do
      cohort = create :cohort, owner: admin
      ag = create :assignment_group, cohort: cohort
      sign_in coach
      get :index
      expect(coach.assignment_groups).not_to include(ag)
    end

    it "cannot get new assignment_group" do
      sign_in coach

      get :new
      expect(response.status).to eq 403
    end

    # crud
    it "cannot create assignment_group" do
      sign_in coach

      expect {
        post :create, assignment_assignment_group: {
          assignment_group_template_id: agt.id
        }
      }.not_to change(Assignment::AssignmentGroup, :count)
    end

    it "get index should be redirected to assignment group" do
      cohort = create :cohort, owner: coach
      ag = create :assignment_group, cohort: cohort
      sign_in coach

      get :index
      expect(response).to be_success
    end

    it "cannot update assignment_group" do
      sign_in coach
      ag = create :assignment_group, title: 'title', desc_md: 'desc'
      put :update, assignment_group_id: ag.id,
        assignment_assignment_group: {
                                   title: 'different title',
                                   desc_md: 'different desc'
      }
      expect(ag).not_to receive(:update_attributes)
      ag.reload
      expect(ag.title).to eq 'title'
      expect(ag.desc_md).to eq 'desc'
    end

    it "cannot delete assignment_group" do
      ag = create :assignment_group
      sign_in coach

      expect {
        delete :destroy, assignment_group_id: ag
      }.not_to change(Assignment::AssignmentGroup, :count)

      expect(response.status).to eq 403
    end
  end

  ##############################################################################
  # student tests
  ##############################################################################
  describe 'student' do

    it "cannot get new" do
      sign_in student
      get :new

      expect(response.status).to eq 403
    end

    # crud
    it "cannot create assignment_group" do
      group_params = FactoryGirl.attributes_for(:assignment_group)
      sign_in student

      expect {
        post :create, assignment_group: group_params
      }.not_to change(Assignment::AssignmentGroup, :count)
    end

    it "get index should be redirected to first assignment group" do
      cohort = create :cohort, users: [student]
      sign_in student
      ag = create :assignment_group, cohort: cohort

      get :index
      expect(response).to redirect_to(assignment_assignment_group_path(ag))
    end

    it "cannot update assignment_group" do
      ag = create :assignment_group, title: 'title'
      sign_in student

      put :update, assignment_group_id: ag,
        assignment_assignment_group: { title: "a different title" }
      expect(ag.title).to eq 'title'
    end

    it "cannot delete assignment_group" do
      ag = create :assignment_group
      sign_in student

      expect {
        delete :destroy, assignment_group_id: ag
      }.not_to change(Assignment::AssignmentGroup, :count)

      expect(response.status).to eq 403
    end
  end
end
