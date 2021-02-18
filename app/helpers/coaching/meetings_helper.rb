module Coaching::MeetingsHelper

  def hf_get_start_time (event_id)
    event = Event.find_by(id: event_id)
    if event.nil?
      return "N/A"
    else
      return event.start_date
    end
  end

  def hf_get_advisor(advisor_id)
    if advisor_id.to_s == ""
      return "N/A"
    end

    if !advisor_id.nil?
      advisor = Advisor.find_by(id: advisor_id)
      if !advisor.nil?
        return advisor.name + " / " + advisor.advisor_type
      else
        return "N/A"
      end
    end 


  end

  def hf_format_subjects(subjects)
    subjects.reject!(&:blank?)
    return subjects.to_csv.gsub(",", "/")
  end

  def hf_get_advisor_name(advisor_id)
    if advisor_id.to_s == ""
      return ""
    end
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

  def hf_academic_primary_for_select
    [
      ["Goal Setting/Updated IPAS"],
      ["General Learning/Study Strategies"],
      ["General Assessment/Test-Taking Strategies"],
      ["Remediation Support"],
      ["Time Management During Blocks/Rotations"],
      ["NBME exams – Comp 4 or Clinical Self-Assessments"],
      ["USMLE – Step 1"],
      ["USMLE - Step 2 CK"],
      ["Clinical Skill Assessments – CSAs, OSCEs, CPX"],
      ["Other"]
    ]
  end

  def hf_career_primary_for_select
    [
      ["Goal Setting/Updated IPPS"],
      ["General Career Advising/Specialty Exploration/Which Specialty Is Right for Me?"],
      ["Electives/Rotation Scheduling Advising"],
      ["Residency Application (ERAS) General Advice"],
      ["Residency Application - Personal Statement Advice"],
      ["Residency Application - Letters of Recommendation Advice"],
      ["Residency Application – Selecting GME Programs to Apply To"],
      ["Residency Application – Interviewing Tips/Best Practices"],
      ["Residency Application – Completing My Rank Order List"],
      ['Residency Application – SOAP Advice ("I’m worried I won’t Match" or "I didn’t initially Match")'],
      ['Transition to Residency – "Now that I’ve matched, advice for next steps before Residency'],
      ['Alternate Careers Advising – "After graduation, what options besides GME can I explore?"']
    ]

  end

  def hf_academic_advisor_discussed_for_select
    [
      ["Meet & Greet (Introduction)"],
      ["General learning & studying support (includes study strategies, time mgt, study schedules)"],
      ["General assessment & test-taking support (includes OHSU developed and NBME/USMLE exams)"],
      ["Remediation support"],
      ["Exploring/planned delay of USMLE exam"],
      ["Individual Plan for Academic Success (iPAS)"],
      ["Other (text box)"]
    ]
  end

  def hf_career_advisor_discussed_for_select
      [
        ["Meet & Greet (Introduction)"],
        ["General career advising and specialty exploration for undecided student"],
        ["Elective advising"],
        ["Identify/connect with Departmentally-Based Residency Specialty Advisor"],
        ["Residency Application Support (ERAS, LORs and letter writers, program selection, personal statements)"],
        ["Residency Interview/NRMP Support (interviewing, ROLs)"],
        ["Un-Match Advising (SOAP)"],
        ["Individual Plan for Professional Success (iPPS)"],
        ["Other (text box)"]
      ]
  end

  def hf_meeting_ipas_for_select
    [
      ["Peer Tutoring"],
      ["Provost’s Student Learning Support Specialist"],
      ["Student Health & Wellness Center"],
      ["Office of Student Access / Explore accommodations"],
	    ["Financial / Debt Mgr"],
	    ["UME curricular leader (block, thread, course, or clinical experience director)"],
      ["Other OASIS advisor"],
      ["UME Student Affairs"],
      ["Other (text box)"]
    ]
  end

  def hf_meeting_ipps_for_select
    [
      ["Dept-based Residency Specialty Advisor connection"],
      ["Online resources explored / encouraged (Careers in Med, Sakai, etc)"],
      ["Student Health & Wellness Center"],
      ["Office of Student Access / Explore accommodations"],
      ["Financial / Debt Mgr"],
      ["UME curricular leader (course or clinical experience director)"],
      ["Other OASIS advisor"],
      ["UME Student Affairs"],
      ["Other (text box)"]
    ]
  end



end
