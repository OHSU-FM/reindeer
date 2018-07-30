class Competency < ApplicationRecord

  belongs_to :user
  has_many :detail_competencies, foreign_key: "917581X668X8100StudentID"

  paginates_per 13

  def detail_competencies
    #DetailCompetency.find_by_sql ['SELECT L.* FROM lime_survey_917581 L
    #WHERE L."917581X668X8100StudentID" = ?', self.student_uid]
    DetailCompetency.where(['"917581X668X8100StudentID" = ?', self.student_uid])
  end

  def overall_competency
    @overall_competency = '%.0f' % ((self.ics + self.mk + self.pbli + self.pcp + self.pppd + self.sbpic)/6)
  end


end
