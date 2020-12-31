module Coaching::MeetingsHelper

  def hf_format_subjects(subjects)
    subjects.reject!(&:blank?)
    return subjects.to_csv.gsub(",", "/")
  end

  def hf_get_advisor_name(advisor_id)
    advisor = Advisor.find_by(id: advisor_id)
    if !advisor.nil?
      return advisor.name
    else
      return ""
    end

  end

  def hf_get_appt_dates(event_id)
    event = Event.find_by(id: event_id)
    if !event.nil?
      return event.start_date.strftime("%m/%d/%Y %T %p"), event.end_date.strftime("%m/%d/%Y %T %p")
    else
      return "", ""
    end
  end


  def hf_meeting_ipas_for_select
    [
      ["Adult Learning Theory"],
      ["Learning Support"],
      ["Study Strategies"],
      ["Study Schedules"],
	    ["Assessment Strategies"],
	    ["Assist Struggling & High Performing Students"],
      ["Remediation strategies"],
      ["Other"]
    ]
  end

  def hf_meeting_ipps_for_select
    [
      ["Specialty speed dating"],
      ["MD panels/career exploration"],
      ["TTCE"],
      ["Residency Apps"],
      ["Residency Interview"]
    ]
  end

end
