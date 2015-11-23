module EdnaConsole::UserHasAssignments
    extend ActiveSupport::Concern
    attr_reader :active_assignments, :completed_assignments

    included do
        has_many :user_assignments, class_name: 'Assignment::UserAssignment' 
    end
    

    ##
    # Limit assignments to ones that actually exist
    def assignments
        @assignments ||= self.user_assignments.order('updated_at DESC').select{|assig|
            assig.lime_survey.lime_data.table_exists? &&
                assig.lime_tokens.table_exists?
        }
    end

    def active_assignments
        @active_assignments ||= assignments.select{|assig| !assig.completed? }
    end
    
    def completed_assignments
        @completed_assignments ||= assignments.select{|assig| !assig.completed? }
    end

end
