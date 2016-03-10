module Assignment

  class UserAssignmentsIndexService
    # provides api to easily index user_assignments along with category & status
    # returns object containing user_assignment-related information
    attr_reader :user_assignments

    def initialize assignment_group, opts={}
      @assignment_group = assignment_group
      @opts = opts
      @user_id = opts[:user_id] if for_user?
      @assignment_group_title = assignment_group.title
      @index = []
    end

    def perform
      if for_user?
        perform_for_user
      else
        @assignment_group.survey_assignments.each do |sa|
          @index << sa.user_assignments
        end
        @index.flatten
      end
    end

    def perform_for_user
      uac = UaCollection.new(@assignment_group.user_assignments_for(@user_id))
      @index = uac.categories_and_responses
    end

    def for_user?
      @opts.has_key?(:user_id) && @opts[:user_id].present?
    end

    # array class for holding user_assignments
    class UaCollection < Array

      def initialize items=nil, opts={}
        @filter = *opts[:filter]
        items = *items
        items.each { |item| push(item) if in_filter?(item) }
      end

      def in_filter? item
        @filter.empty? || @filter.include?(item.title)
      end

      def categories_and_responses
        h = Hash.new
        map {|ua|
          ua.lime_groups.each do |lg|
            if lg.contains_visible_questions?
              group_name = lg.group_name.to_s
              h[group_name] = []
              lg.lime_questions.each do |lq|
                row = []
                response_key = "#{lg.sid}X#{lg.gid}X#{lq.qid}"
                ua.response_data.each do |key, value|
                  if key.include? response_key
                    row << value unless value.to_s == ''
                  end
                end
                h[group_name] << row unless row.empty?
              end
              h[group_name] = h[group_name].transpose
            end
          end
        }
        h
      end

    end

  end
end
