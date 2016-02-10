##
# Sort role_aggregates into groups based on their group name
# RoleAggregateGroup.classify(role_aggregates) 
class PermissionGroups::RoleAggregateGroup
  attr_reader :role_aggregates, :group_title

  def self.classify role_aggregates
    role_aggregates = role_aggregates.to_a.dup
    groups = []
    while role_aggregates.present?
      groups.push(new(role_aggregates))  
    end
    groups
  end

  protected

  def initialize role_aggregates
    @role_aggregates = []
    role_aggregates.delete_if{|ra|@role_aggregates.push(ra) if in_group?(ra)}
  end

  def surveys
    @surveys ||= role_aggregates.map{|ra|ra.lime_survey}
  end

  protected
  
  def in_group?(role_aggregate)
    g_title, ra_title = role_aggregate.lime_survey.group_and_title_name
    @group_title ||= g_title
    group_title == g_title
  end
  
  alias_method :title, :group_title
  alias_method :lime_surveys, :surveys

end
