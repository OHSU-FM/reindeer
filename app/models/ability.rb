class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new                   # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, to: :crud
    alias_action :create, :update, :destroy, to: :alter
    alias_action :read, :update, to: :modify

    all_users_permissions user
    # Normal admin function
    if user.admin_or_higher?
      admin_users_permissions user
    else
      other_users_permissions user
    end

    # coaching system abilities
    if ["coach", "student", "dean"].include? user.coaching_type
      self.send("#{user.coaching_type}_permissions", user)
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

  # Permissions for all users (logged in or not)
  def all_users_permissions user
    can :list, LimeSurvey
  end

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
      can :debug, :dashboard
      can :manage, :all
      can :read, :lime_survey_website
    end
  end

  # Non Admin users
  def other_users_permissions user
    can :update, User, id: user.id
    can :read, User, id: user.id

    # Allow access to Dashboard functionality
    if user.can_dashboard?
      can :list, Dashboard    # Own dash listed in index
      can :access, Dashboard  # ditto
      can :crud, QuestionWidget, user_id: user.id
      can :crud, Dashboard, user_id: user.id
    end

    # Allow access to Chart functionality
    #commented these codes out on 11/18/2024
    # if user.can_chart?
    #   can :list, Chart
    #   can :access, Chart
    #   # Can manage their own charts only
    #   can :crud, Chart, user_id: user.id
    #   can :crud, QuestionWidget, user_id: user.id
    # end

    can :read, LimeSurvey do |lime_survey|
      # We check permissions by checking if permission_group says everything is ready
      # If we are missing user_externals etc... you will still receive a true on can? :read
      # But will throw an error on the view (handled in dashboard/ ls_reports:index etc..)
      if user.permission_group_id.present?
        #plg = user.permission_group.permission_ls_groups.where(lime_survey_sid: lime_survey.sid).first
        plg = PermissionLsGroup.where(permission_group_id: user.permission_group_id, lime_survey_sid: lime_survey.sid).first
        if plg.nil?
          if user.prev_permission_group_id.present?
            plg = PermissionLsGroup.where(permission_group_id: user.prev_permission_group_id, lime_survey_sid: lime_survey.sid).first
          end
        end
        plg.present? && plg.ready_for_use?
      else
        false
      end
    end

    can :read_unfiltered, LimeSurvey do |lime_survey|
      if user.permission_group_id.present?

          # if user.lime_surveys.include? lime_survey
          #   plg = user.permission_group.permission_ls_groups.where(lime_survey_sid: lime_survey.sid).first
          #   (plg.present? && plg.ready_for_use? && plg.view_all) ? true : false
          # else
          #   byebug
          #   false
          # end
        plg = PermissionLsGroup.where(permission_group_id: user.permission_group_id, lime_survey_sid: lime_survey.sid).first
        if plg.present?
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
        #has_ls = user.role_aggregates.map{|ra| ra.lime_survey_sid }.include? lime_survey.sid

        if user.lime_surveys.include? lime_survey
          plg = user.permission_group.permission_ls_groups.where(lime_survey_sid: lime_survey.sid).first
          if plg.nil?
            if user.prev_permission_group_id.present?
              plg = PermissionLsGroup.where(permission_group_id: user.prev_permission_group_id, lime_survey_sid: lime_survey.sid).first
            end
          end
          (plg.present? && plg.ready_for_use? && plg.view_raw) ? true : false
        else
          # dean level
          false
          # byebug
          #  plg = PermissionLsGroup.where(permission_group_id: user.permission_group_id, lime_survey_sid: lime_survey.sid).first
          #  if plg.present?
          #    (plg.present? && plg.ready_for_use? && plg.view_raw) ? true : false
          #  else
          #     false
          #  end
        end
      else
        false
      end
    end

    # if user.lime_user
    #   can :access, :lime_server
    # end
  end

  def student_permissions user
    can :read, Student
    can :create, Coaching::Goal
    can :create, Coaching::Meeting
    can :modify, Coaching::Goal do |goal|
      goal.user == user
    end
    can :modify, Coaching::Meeting do |m|
      m.user == user
    end
    cannot :read, EpaMaster
    cannot :read, EgCohort
    cannot :read, EpaReview
    cannot [:index, :competency, :mspe, :download_file], ReportsController
  end

  def coach_permissions user
    can :read, Student
    can :create, Coaching::Goal
    can :create, Coaching::Meeting
    can :modify, Coaching::Goal do |goal|
      user.cohorts.include? goal.user.cohort
    end
    can :modify, Coaching::Meeting do |m|
      user.cohorts.include? m.user.cohort
    end
  end

  def dean_permissions user
    can :read, Student
    can :read, Coaching::Goal
    can :read, Coaching::Meeting
  end

  def admin_permissions user
    can :manage, :all
  end
end
