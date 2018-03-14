module Coaching::StudentsHelper

  # returns true if this cohort contains the selected student
  # @param {Cohort} cohort
  # @param {User} student
  # @return {Boolean}
  def hf_active_cohort? cohort, student
    student.cohort == cohort
  end

  # returns the competency_tag hash with human readable version for translation
  def hf_competency_tags_for_select
    [
      ["Patient Care (PC)", "pc"],
      ["Practice Based Learning & Improvement (PBLI)", "pbli"],
      ["Medical Knowledge (MK)", "mk"],
      ["Sysetms Based Practice (SBP)", "sbp"],
      ["Professionalism (P)", "p"]
    ]
  end

  # returns the long form human readable version of a competency tag
  # @param {String} c_tag
  # @return {String} long competency tag (ex: Patient Care (PC))
  def hf_tag_to_human c_tag
    hf_competency_tags_for_select.each do |ary|
      return ary.first if ary.second == c_tag
    end
  end

  # returns the short form human readable version of a competency tag
  # @param {String} c_tag
  # @return {String} short competency tag (ex: PC)
  def hf_tag_to_short_human c_tag
    long = hf_tag_to_human c_tag
    return long[/\(([^)]+)\)/].gsub(/[()]/, "")
  end

  def hf_sort_link column, title = nil
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    icon = sort_direction == "asc" ? "glyphicon glyphicon-chevron-up" : "glyphicon glyphicon-chevron-down"
    icon = column == sort_column ? icon : ""
    link_to "#{title} <span class='#{icon}'></span>".html_safe, { column: column, direction: direction }
  end


end
