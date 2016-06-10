module Assignment

  class UserAssignmentsIndexService
    # provides api to easily index user_assignments along with metadata
    attr_reader :index
    attr_reader :survey_types

    def initialize assignment_group, opts={}
      @user_id = opts[:user_id] if for_user? opts
      perform assignment_group, opts
    end

    def perform assignment_group, opts={}
      if @user_id
        perform_for_user assignment_group
      else
        assignment_group.survey_assignments.each do |sa|
          @index << sa.user_assignments
        end
        @index.flatten
      end
    end

    protected

    def for_user? opts
      opts.has_key?(:user_id) && opts[:user_id].present?
    end

    def perform_for_user assignment_group
      @index = assignment_group.user_assignments_for @user_id
      @survey_types = UACollection.new(@index).survey_types_enum
        .sort_by(&:downcase)
      @recent = @survey_types.map do |t|
          @index.select{|ua|
          ua.survey_type == t
          }.sort_by(&:created_at).last
      end
    end
  end
end
