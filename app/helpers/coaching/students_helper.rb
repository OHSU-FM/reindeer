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
end
