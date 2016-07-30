module Assignment

  class UserAssignmentsIndexService
    # provides api to easily index user_assignments along with metadata
    def initialize assignment_group, params
      @assignment_group = assignment_group
      @user_id = params[:user_id] if for_user? params
    end

    def index
      if @user_id
        get_index
      else
        idex = []
        @assignment_group.survey_assignments.each do |sa|
          idex << sa.user_assignments
        end
        idex.flatten
      end
    end

    def survey_types
      get_ua_collection
    end

    def recent
      get_recent
    end

    protected

    def for_user? params
      params.has_key?(:user_id) && params[:user_id].present?
    end

    def get_index
      @assignment_group.user_assignments_for @user_id
    end

    def get_ua_collection
      UACollection.new(get_index).survey_types_enum.sort_by(&:downcase)
    end

    def get_recent
      get_ua_collection.map do |t|
          get_index.select{|ua|
          ua.survey_type == t
          }.sort_by(&:created_at).last
      end
    end
  end
end
