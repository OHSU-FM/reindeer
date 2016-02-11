class PermissionLsGroup < ActiveRecord::Base
    belongs_to :lime_survey, :primary_key=>:sid, :foreign_key=>:lime_survey_sid, :inverse_of=>:permission_ls_groups
    has_one :role_aggregate, :through=>:lime_survey

    belongs_to :permission_group, :inverse_of=>:permission_ls_groups
    has_many :permission_ls_group_filters, :dependent=>:destroy, :inverse_of=>:permission_ls_group

    validates_presence_of :lime_survey_sid, :permission_group_id
    validates_presence_of :role_aggregate
    validates_uniqueness_of :lime_survey_sid, :scope=>:permission_group_id
    accepts_nested_attributes_for :permission_ls_group_filters, :allow_destroy=>true
    attr_accessible :lime_survey_sid, :permission_group_id, :view_raw, :enabled, :view_all
    attr_accessible :permission_ls_group_filters_attributes, :allow_destroy=>true
    validate :validate_enabled_allowed

    def validate_enabled_allowed
        if enabled && !enabled_allowed?
            if !role_aggregate.present?
                # Must explicitly allow view_all, or have filters
                errors.add(:enabled, 'No role_aggregate defined')
            elsif !role_aggregate.ready_for_use?
                errors.add(:enabled, 'Role aggregate configuration is not complete')
            else
                # Must explicitly allow view_all, or have filters
                errors.add(:enabled, 'requires "view all" or enabled filters')
            end
        end
    end

    def enabled_allowed?
        return role_aggregate.present? && role_aggregate.ready_for_use? && (
            view_all == true || permission_ls_group_filters.select{|plgf|plgf.enabled?}.count > 0
        )
    end

    def ready_for_use?
        enabled && enabled_allowed?
    end

    rails_admin do
        navigation_label 'Permissions'
        label 'Lime Survey'
        visible false
        list do
            field :id do
                pretty_value do
                    bindings[:view].link_to(bindings[:object].id, bindings[:view].edit_path(bindings[:object].class, bindings[:object].id))
                end
            end
            field :enabled
            field :ready_for_use?, :boolean do
                read_only true
            end
            field :permission_group
            field :lime_survey
            field :view_raw
            field :view_all
            field :updated_at
            field :created_at
            sort_by "permission_group_id, lime_survey_sid"
        end

        edit do
            field :ready_for_use?, :boolean do
                read_only true
            end

            field :permission_group do
                inline_add false
                inline_edit false
            end

            field :lime_survey do
                associated_collection_cache_all false
                associated_collection_scope do
                    plg = bindings[:object]
                    Proc.new { |scope|
                        if plg.present?
                            scope = scope.
                              where('sid = ? OR sid not in (?)',
                                    plg.lime_survey.sid,
                                    plg.permission_group.lime_surveys.map{|ls|
                                      ls.sid})
                        else
                          scope.with_role_aggregate
                        end
                    }
                end
            end
            field :enabled
            field :view_raw
            field :view_all
            field :permission_ls_group_filters do
                label 'Survey permissions'
            end
        end
    end

    def name
        _name = lime_survey.nil? ? 'Untitled' : lime_survey.title
        "#{_name}#{' (disabled)' if disabled?}"
    end

    def disabled?
        !ready_for_use?
    end

end

