module Assignment
  class ListAssignmentsService
    attr_reader :user_assignments

    def initialize user, opts={}
      @user_id = opts[:user_id] || user.id
      @assignment_group_name = opts[:assignment_group]
      @user_assignments = Assignment::UserAssignment.include(:assignment_group).include()
    end

    def assignment_groups

    end

  end
end
