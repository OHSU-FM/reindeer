##
# Sort lime_surveys into groups based on their group name
# RoleAggregateGroup.classify(lime_surveys)
class LimeExt::LimeSurveyGroup

  def self.classify(lime_surveys, opts={})
    # dup our own copy of array to mutate
    lime_surveys = if opts[:pk_filter].present?
      pk_list lime_surveys.to_a.dup, *opts[:pk_filter]
    else
      lime_surveys.to_a.dup
    end

    groups = GroupCollection.new
    while lime_surveys.present?
      groups.push(new(lime_surveys))
    end

    # Filter groups if filter present
    group_filter = *opts[:group_filter]
    if group_filter.present?
      groups.select!{|group| group_filter.include?(group.title) }
    end
    groups
  end

  def initialize lime_surveys
    @lime_surveys = []
    lime_surveys.delete_if{ |ls| @lime_surveys.push(ls) if in_group?(ls) }
  end

  def role_aggregates
    @role_aggregates ||= surveys.map{|survey| survey.role_aggregate }
  end

  def self.pk_list lime_surveys, pk
   lime_surveys.map {|survey|
      survey.student_email_column
    }.compact.select {|column_name|
      check_table("lime_survey_#{column_name.split("X").first}", column_name, pk)
    }.map {|column_name| LimeSurvey.find(column_name.split("X").first.to_i)}
  end

  def self.check_table(table_name, col_name, pk)
    LimeTable.table_name = table_name
    LimeTable.where("#{col_name}": pk).present?
  end

  def title
    @group_title
  end

  def group_title
    title
  end

  def surveys
    @lime_surveys
  end

  def lime_surveys
    surveys
  end

  protected

  ##
  # Is title a part of this group?
  def in_group?(lime_survey)
    g_title, ra_title = lime_survey.group_and_title_name

    @group_title ||= g_title
    @group_title == g_title
  end

  ##
  # Simple array class for holding a collection of
  # survey groups
  class GroupCollection < Array

    def initialize( items=nil, opts={} )
      @group_filter = *opts[:group_filter]
      items = *items
      items.each{|item| push(item) if in_filter?(item) }
    end

    def in_filter? item
      @group_filter.empty? || @group_filter.include?(item.title)
    end

    def group_filter filter
      self.class.new(self, group_filter: filter)
    end

    def titles
      map{|group|group.title}
    end

    def role_aggregates
      map{|group|group.role_aggregates}.flatten
    end

    def lime_surveys
      map{|group|group.lime_surveys}.flatten
    end
  end
end

class LimeTable < ActiveRecord::Base
end
