##
# Sort lime_surveys into groups based on their group name
# RoleAggregateGroup.classify(lime_surveys) 
class LimeExt::LimeSurveyGroup
  attr_reader :lime_surveys, :group_title
  alias_method :title, :group_title
  alias_method :surveys, :lime_surveys


  def self.classify(lime_surveys, opts = {})
    lime_surveys = lime_surveys.to_a.dup
    
    groups = GroupCollection.new
    while lime_surveys.present?
      groups.push(new(lime_surveys))  
    end
    
    # Filter groups if filter present
    if opts[:filter].present?
      groups.select!{|group|group.title == opts[:filter]}
    end
    groups
  end

  def initialize lime_surveys
    @lime_surveys = []
    lime_surveys.delete_if{|ra|@lime_surveys.push(ra) if in_group?(ra)}
  end

  def role_aggregates
    @role_aggregates ||= surveys.map{|survey| survey.role_aggregate}
  end

  protected


  def in_group?(lime_survey)
    g_title, ra_title = lime_survey.group_and_title_name
    @group_title ||= g_title
    group_title == g_title
  end
  
  class GroupCollection < Array
    def role_aggregates
      map{|group|group.role_aggregates}.flatten
    end

    def lime_surveys
      map{|group|group.lime_surveys}.flatten
    end
  end
end
