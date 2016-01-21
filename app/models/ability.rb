class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new                   # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, :to => :crud
    alias_action :create, :update, :destroy, :to=> :alter

    all_users_permissions user
    # Normal admin function
    if user.admin_or_higher?
        admin_users_permissions user
    else
        other_users_permissions user
    end

    # Do not allow people to:
    # - alter the flow of time
    # - change the course of known history
    # - cross the streams. DO NOT CROSS THE STREAMS!
    cannot :alter, Version
    # Also, lets not mess with Lime Either
    cannot :alter, LimeUser
    cannot :alter, LimeSurvey
    cannot :alter, LimeGroup
    cannot :alter, LimeQuestion
    cannot :alter, LimeAnswer
  end

  ##
  # Permissions for all users (logged in or not)
  def all_users_permissions user
    can :list, LimeSurvey #if user.role_aggregates.count > 0
  end

  ##
  # Permissions for admin users
  def admin_users_permissions user
        can :read, :all
        can :access, :rails_admin
        can :update, User do |user|
            !(user.admin? || user.superadmin?)
        end
        can :crud, RoleAggregate
        can :crud, Dashboard
        can :crud, DashboardWidget
        can :crud, QuestionWidget
        can :crud, Dashboard
        if user.superadmin?
            # Super powers!!
            can :debug,  :dashboard
            can :manage, :all
            can :read, :lime_survey_website
        end

  end

  ##
  # Non Admin users
  def other_users_permissions user
        can :update, User, :id=>user.id
        can :read, User, :id=>user.id

        # Allow access to Dashboard functionality
        if user.can_dashboard?
            can :list, Dashboard    # Own dash listed in index
            can :access, Dashboard  # ditto
            can :crud, QuestionWidget , :user_id=>user.id
            can :crud, Dashboard, :user_id=>user.id
        end

        # Allow access to Chart functionality
        if user.can_chart?
            can :list, Chart
            can :access, Chart
            # Can manage their own charts only
            can :crud, Chart, :user_id=>user.id
            can :crud, QuestionWidget, :user_id=>user.id
        end

        can :read, LimeSurvey do |lime_survey|
            # We check permissions by checking if permission_group says everything is ready
            # If we are missing user_externals etc... you will still receive a true on can? :read
            # But will throw an error on the view (handled in dashboard/ ls_reports:index etc..)
            if user.permission_group_id.present?
                plg = user.permission_group.permission_ls_groups.where(:lime_survey_sid=>lime_survey.sid).first
                plg.present? && plg.ready_for_use?
            else
                false
            end
        end

        can :read_unfiltered, LimeSurvey do |lime_survey|
            if user.permission_group_id.present?
                has_ls = user.role_aggregates.map{|ra|ra.lime_survey_sid}.include? lime_survey.sid
                if has_ls
                    plg = user.permission_group.permission_ls_groups.where(:lime_survey_sid=>lime_survey.sid).first
                    (plg.present? && plg.ready_for_use? && plg.view_all) ? true : false
                else
                    false
                end
            else
                false
            end
        end

        # If a user is allowed to view a given survey and they can 'view_spreadsheet' then allow them to view it
        can :read_raw_data, LimeSurvey do |lime_survey|
            if user.permission_group_id.present?
                has_ls = user.role_aggregates.map{|ra|ra.lime_survey_sid}.include? lime_survey.sid
                if has_ls
                    plg = user.permission_group.permission_ls_groups.where(:lime_survey_sid=>lime_survey.sid).first
                    (plg.present? && plg.ready_for_use? && plg.view_raw) ? true : false
                else
                    false
                end
            else
                false
            end
        end

        if user.lime_user
            can :access, :lime_server
        end
  end

end
