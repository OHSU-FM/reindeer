module LsReportsHelper

  def hf_sidebar_link_label question, full_desc
    (full_desc ? strip_tags(question.question) : question.title.titleize).html_safe
  end


    class AccessDenied < Exception; end

    MAX_Q = 10

    ##
    # Generate a unique cache key for this Group ID (and its user's filters)
    def cache_key_for_group virt_group, opts={}
        group = virt_group.group
        query = group.lime_survey.lime_data.query
        updated_at = group.lime_survey.role_aggregate.updated_at
        gid = group.gid
        "ls_reports/show_part/updated_at=#{updated_at}/query=#{query}/gid=#{gid}/view_type=#{opts[:view_type]}/for=#{opts[:for]}"
    end

    ##
    # Generate a unique cache key for this survey(and user's filters)
    def cache_key_for_survey survey
        query = survey.lime_data.query
        updated_at = survey.role_aggregate.updated_at
        "ls_reports/show/sid=#{survey.sid}/updated_at=#{updated_at}/query=#{query}"
    end

 def lime_file_links question
     raise 'Not a file question' unless question.qtype == 'file_upload'
     links = []
     ldata = question.response_set.data || []
     ldata.each do |dat|
         f_links = []
         dat_files = dat[:files] || []
         dat_files.each do |finfo|
             link = link_to(
                 finfo['name'],
                 lime_file_path(:sid=>question.sid, :row_id=>dat[:row_id], :name=>finfo['name'], :qid=>question.qid)
             )
             f_links.push link
         end
         links.push f_links
     end
     return links
 end

    ##
    # Helper function
    def hf_role_aggregate_groups(role_aggregates)
        result = {}
        # A list of role_aggregates
        role_aggregates.each do |ra|
            g_title, ra_title = ra.lime_survey.group_and_title_name
            # Throw each ra into a group
            result[g_title] = [] unless result.include? g_title
            result[g_title].push([ra_title, ra])
        end
        # Sort each group by the 'last_updated' value in lime_survey
        result.each do |g, ras|
            ras.sort_by!{|title, ras|ras.lime_survey.last_updated.to_s}
        end
        return result
    end

    ##
    #
    def hf_lime_url pquestion
        sid = pquestion.sid
        gid = pquestion.gid
        qid = pquestion.qid
        if can? :read, :lime_survey_website
            return "#{Settings.lime_url}index.php/survey/index/action/previewquestion/sid/#{sid}/gid/#{gid}/qid/#{qid}"
        else
            return ''
        end
    end

    ##
    # TODO: Move to ls_files_helper.rb
    class FileAccessRequest
        attr_reader :fm, :col_id, :row_id

        def initialize fm, col_id, row_id
            @fm = fm
            @col_id = col_id
            @row_id = row_id
        end

        def question
            @question ||= fm.lime_survey.find_question :col_id=>col_id
        end

        def can_access?
            fm.lime_survey
        end

    end

    ##
    # Move to lib/lime_ext?
    class FilterManager
        attr_reader :hide_pk, :hide_agg, :lime_survey, :lime_survey_unfiltered, :pk, :agg, :pk_enum, :agg_enum, :params, :user,
            :filters_equal, :series_name, :unfiltered_series_name

        def initialize user, sid, opts={}
            @user = user
            @ability = Ability.new user
            @sid = sid
            @hide_agg = opts[:hide_agg] || false
            @hide_pk = opts[:hide_pk] || false
            @params = opts[:params].is_a?(Hash) ? opts[:params] : {}
            its_important_to_check_ids
            add_permission_group_filters
            add_all_param_filters
            do_titles
            Rails.logger.info lime_survey.lime_data.query
            Rails.logger.info lime_survey_unfiltered.lime_data.query
        end

        def its_important_to_check_ids
            raise "Identical Survey Object ids" if lime_survey.object_id == lime_survey_unfiltered.object_id
            raise "Identical Data Object ids" if lime_survey.lime_data.object_id == lime_survey_unfiltered.lime_data.object_id
            raise "Identical Stats Object ids" if lime_survey.lime_stats.object_id == lime_survey_unfiltered.lime_stats.object_id
        end

        ##
        # Set nothing found
        def not_found
            @not_found = true
        end

        ##
        # Check to see if anything was found
        def not_found?
            @not_found = false unless defined? @not_found
            return @not_found
        end

        ###
        # Aliases

        def role_aggregate
            @role_aggregate ||= lime_survey.role_aggregate
        end

        def lime_survey
            # Load resource and pre-load associations
            @lime_survey ||= get_lime_survey @sid
        end

        def lime_survey_unfiltered
            # Load resource and pre-load associations
            @lime_survey_unfiltered ||= get_lime_survey @sid
        end

        ##
        # Load LimeSurvey and associations
        def get_lime_survey sid
            cache_key = "filter_manager/survey/sid=#{sid}/updated_at=#{RoleAggregate.where(:lime_survey_sid=>sid).pluck(:updated_at).first.to_i}"
            result = Rails.cache.fetch(cache_key, race_condition_ttl: 10) do
                # Load resource and pre-load associations
                LimeSurvey.includes(:role_aggregate,
                :lime_groups=>[
                    :lime_questions=>[
                        :lime_answers,
                        :lime_question_attributes
                    ]
                ]).where(:sid=>sid.to_i).first
            end
            raise ActiveRecord::RecordNotFound unless result

            # !!!!!!!!!!! Important !!!!!!!!!!!!
            # Must marshal/de-marshal in order to prevent return of identical objects
            result = Marshal.load(Marshal.dump(result))
            return result
        end

        ##
        # Generate array of virtual groups
        def virtual_groups
            return @virtual_groups if defined? @virtual_groups

            @virtual_groups = []
            # Process every group
            lime_survey.lime_groups.each do |group|
                next unless group.contains_visible_questions?
                @virtual_groups += VirtualGroup.spread group
            end
            return @virtual_groups
        end

        ##
        # Agg enumerator for links
        def agg_enum
            # Enums for filtering in view
            # NO BYREF - Dup array first
            @agg_enum ||= role_aggregate.agg_enum.dup.unshift(['All', ''])
        end

        ##
        # PK enumerator for links
        # NO BYREF - Dup array first
        def pk_enum
            @pk_enum ||= role_aggregate.pk_enum.dup.unshift( ['All', '_' ])
        end

        def filters_equal
            lime_survey.lime_data.filters == lime_survey_unfiltered.lime_data.filters
        end

        #############################
        #private

        ##
        # Add user lime permissions to lime_survey
        def add_permission_group_filters
            unless @ability.can? :read, lime_survey
                raise LsReportsHelper::AccessDenied
            end

            unless @ability.can? :read_unfiltered, lime_survey
                # Filters for comparison
                plg = user.permission_group.permission_ls_groups.where(:lime_survey_sid=>lime_survey.sid).first
                raise "Permissions Error: User cannot access this survey" unless plg.present?
                uexts = user.user_externals
                plg.permission_ls_group_filters.each do |plgk|
                    fieldname = plgk.lime_question.my_column_name
                    if plgk.restricted_val.present?
                        filter_val = plgk.restricted_val
                    else
                        uex = plgk.user_externals.where(:user_id=>@user.id).first
                        raise 'Permissions Error: UserExternal is missing' unless uex.present?
                        filter_val = uex.filter_val
                    end
                    add_x_filters fieldname, filter_val, plgk.filter_all
                end
            end
            @hide_agg = true if role_aggregate.agg_fieldname.to_s.empty?
        end

        ##
        # Add a filter to one or both datasets/surveys
        def add_x_filters fieldname, filter_val, filter_all
            # Add filter to filtered dataset
            lime_survey.add_filter fieldname, filter_val

            # Filter both if the ULP says to
            if filter_all
                lime_survey_unfiltered.add_filter fieldname, filter_val
            end
        end

        ##
        # Add filters from params
        def add_all_param_filters
            agg_enum # Load and cache agg_enum

            unless @hide_agg
                @agg = add_param_filter lime_survey, :agg, role_aggregate.agg_fieldname
                # Make sure unfiltered dataset has agg filtered
                add_param_filter lime_survey_unfiltered, :agg, role_aggregate.agg_fieldname
            end

            pk_enum # Load and cache pk_enum

            unless @hide_pk
                @pk = add_param_filter lime_survey, :pk, role_aggregate.pk_fieldname
            end
        end


        ##
        # Add a filter to a survey
        def add_param_filter cur_survey, filter_name, fieldname
            return nil if not_found?                                # We're going to throw an error, bail
            return nil if fieldname.to_s.empty?                     # No filter to use
            return nil if @params[filter_name].to_s.empty?     # No filter val specified
            filter_val = @params[filter_name]
            return nil if filter_val == '_'                         # Blank filter val specified
            cur_survey.add_filter(fieldname, filter_val)   # Add filter
            return filter_val
        end

        # Generate titles for each series
        def do_titles
            @series_name = build_title(lime_survey).map{|k,v|"#{k}(#{v})"}.join(', ')
            @unfiltered_series_name = build_title(lime_survey_unfiltered).map{|k,v|"#{k}(#{v})"}.join(', ')
        end

        # Build the title for an individual dataset
        def build_title survey
            result = []
            ra = survey.role_aggregate
            survey.lime_data.filters.uniq.each do |filter|
                # Check agg_enum for a match to this value
                title = get_title ra.agg_enum, filter[:val]
                result.push([ra.get_agg_label, title]) if title
                next if title # Found match for this filter, do next filter

                title = get_title ra.pk_enum, filter[:val]
                result.push([ra.get_pk_label, title]) if title

            end
            return result.uniq
        end

        # Helper for title builder
        def get_title enum, filter_val
            if enum
                enum.each{|key, val| return key if val == filter_val }
            end
            return nil
        end

    end

    ##
    # Does this user have a widget for this pk, agg and question?
    def user_has_widget? user, question, pk, agg, view_type, graph_type
        !user.question_widgets.find{|qw|
            qw.lime_question_qid == question.qid &&
                qw.agg=agg.to_s && qw.pk==pk.to_s &&
                qw.view_type.to_s == view_type.to_s &&
                qw.graph_type.to_s == graph_type.to_s}.nil?
    end

    ##
    # Virtual Groups: Split lime groups into groups with
    # at most 10 parent questions each.
    class VirtualGroup
        attr_reader :group
        @questions = []

        ##
        # Spread this group into multiple virtual groups if needed
        def self.spread group
            result = []
            idx = 0
            loop do
                virt_group = self.new group, idx
                result.push virt_group
                idx += 1
                break unless virt_group.questions_after_ubound?
            end
            return result
        end

        ##
        # Create a new virtual group, offset allows it to possibly be a part of another virtual group
        def initialize group, offset
            @group = group
            @offset = offset
        end

        ##
        # Debugger output
        def inspect
            vars = "group_name=#{group_name} "
            vars += "@parent_questions=[#{parent_questions.map{|pq|pq.qid}.join(', ')}] "
            attrs = [:@offset, :@lbound, :@ubound]
            vars += attrs.map{|v| "#{v}=#{instance_variable_get(v).inspect}"}.join(", ")
              "<#{self.class}: #{vars}>"
        end

        ##
        # Aliased method call to group name of lime group
        def group_name
            "#{@group.group_name} #{roman_name if multipart?}"
        end

        ##
        # Parent Questions of Lime Group
        def parent_questions
            valid_questions[lbound...ubound]
        end

        ##
        # Subset of valid parent questions available in this group
        def valid_questions
            @valid_questions ||= @group.parent_questions.select{|pq|!pq.hidden?}
        end

        ##
        # gid for this group, includes roman_name if multipart? true
        def gid
            @gid ||= multipart? ? "#{@group.gid}_#{roman_name}": @group.gid
        end

        ##
        # Roman numeral name for group number
        def roman_name
            @roman_name ||= (@offset + 1).to_roman
        end

        ##
        # Is this group part of multiple virtual groups?
        def multipart?
            @multipart ||= valid_questions.size > MAX_Q
        end

        ##
        # Are there valid questions outside of our bounds?
        def questions_after_ubound?
            return false if parent_questions.empty?
            valid_questions.last.qid != parent_questions.last.qid
        end

        ##
        # Upper bound of array index
        def ubound
            @ubound ||= lbound+MAX_Q
        end

        ##
        # Lower bound of array index
        def lbound
            @lbound ||= @offset*MAX_Q
        end
    end
end
