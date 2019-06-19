module Coaching::MeetingsHelper

  def hf_format_subjects(subjects)
    subjects.reject!(&:blank?)
    return subjects.to_csv.gsub(",", "/")
  end

end
