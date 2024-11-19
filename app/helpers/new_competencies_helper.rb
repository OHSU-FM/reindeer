module NewCompetenciesHelper

  NEW_COMP_ASSESSORS = {
    "ics1" => 15,
    "ics2" => 3,
    "ics3" => 9,
    "ics4" => 3,
    "ics5" => 13,
    "mk1" => 4,
    "mk2" => 9,
    "mk3" => 6,
    "pbli1" => 16,
    "pbli2" => 7,  # original was 13
    "pbli3" => 7,
    "pcp1" => 8,
    "pcp2" => 16,
    "pcp3" => 9,
    "pppd1" => 12,
    "pppd2" => 16,
    "sbpic1" => 6
  }

  NEW_COMP_DEFINITION = {
    "ics1" => "Communicate effectively with patients and families.",
    "ics2" => "Communicate effectively with physicians and physicians in training.",
    "ics3" => "Collaborate effectively with non-physician health professionals as a part of healthcare team to coordinate patient care.",
    "ics4" => "Communicate a patient handover to transition responsibility of care.",
    "ics5" => "Access, review, and contribute to the electronic health record and other technologies.",
    "mk1" => "Demonstrate foundational knowledge in basic science.",
    "mk2" => "Demonstrate foundational knowledge in clinical science.",
    "mk3" => "Demonstrate foundational knowledge in health systems science.",
    "pbli1" => "Demonstrate behaviors that support lifelong learning and professional growth such as incorporating self-assessment and feedback.",
    "pbli2" => "Locate, critically appraise, and synthesize new information to support evidence informed and patient centered clinical decisions.",
    "pbli3" => "Engage in scholarly inq@comp_data_clinicaluiry and disseminate findings using ethical principles.",
    "pcp1" => "Gather information through history and physical on patients.",
    "pcp2" => "Construct prioritized differential diagnosis based on interpretation of available clinical data.",
    "pcp3" => "Develop and implement a personalized management plan for the patient.",
    "pppd1" => "Identify and address the negative effects of structural and social determinants of health for patients with diverse needs.",
    "pppd2" => "Demonstrate behaviors that are reflective of professional values of truthfulness, timeliness, accountability, and follow through.",
    "sbpic1" => "Engage in the quality improvement process related to patient safety and system issues."

  }

  NEW_COMP_CODES = ["ics1", "ics2", "ics3", "ics4", "ics5", "mk1", "mk2", "mk3", "pbli1", "pbli2", "pbli3", "pcp1", "pcp2", "pcp3", "pppd1", "pppd2",  "sbpic1"]

  NEW_EPA = { "epa1" => ["pcp1", "ics1", "ics5", "pppd1", "pppd2" ], #done
       "epa2" => ["pcp1", "pcp2",  "mk1", "mk2", "mk3", "pbli1", "ics2","pbli1", "pppd2"],  # done
       "epa3" => ["pcp2",  "mk1", "mk2", "mk3",  "pbli2", "ics1", "pppd1", "pbli1", "pppd2", "sbpic1" ], #done
       "epa4" => ["pcp2", "pcp3", "mk1", "mk2", "mk3", "pbli1", "pbli2",  "ics1",  "pbli1", "pppd2", "sbpic1"], #done
       "epa5" => ["pcp3", "mk3", "ics1", "ics5", "ics2", "pbli1", "pppd2", "sbpic1",  "ics3"], # done
       "epa6" => ["pcp3", "pbli1", "pbli3", "ics1", "ics2", "ics4", "ics5", "pppd1", "pbli1", "pppd2", "pbli1", "ics3"], #done
       "epa7" => ["mk1", "mk2", "mk3", "pbli1", "pbli2", "pbli3", "pppd2" ], #done
       "epa8" => ["ics5", "ics2",  "ics1", "pbli1", "pppd2", "ics3"],  #done
       "epa9" => ["mk3", "ics1", "ics2", "pppd1", "pbli1", "pppd2",  "ics3"], # done
       "epa10" => ["pcp1", "pcp2", "pcp3",  "mk2", "ics1", "ics2", "pppd1", "pppd2", "pbli1", "ics3"], #done
       "epa11" => ["pcp3", "mk1", "mk2", "mk3", "ics1", "ics5", "pbli1", "pppd2", "sbpic1"]

     }
   NEW_EPA_DESC={
             "EPA1a" => "Obtain a hypothesis-driven history",
             "EPA1b" => "Perform a tailored physical examination",
             "EPA2" => "Generate a prioritized differential diagnosis for a clinical encounter",
             "EPA3" => "Interpret Diagnostic or screening tests for a clinical encounter",
             "EPA4" => "Enter orders including prescriptions for a clinical encounter",
             "EPA5" => "Document a clinical encounter in the patient record",
             "EPA6" => "Provide an oral presentation of a clinical encounter",
             "EPA7" => "Use literature to make a patient care recommendation",
             "EPA8" => "Communicate a patient handover to transition responsibility of care",
             "EPA9" => "Advance patient care through interprofessional collaboration",
             "EPA10" => "Recognize a patient requiring urgent assessment and escalate care",
             "EPA11" => "Lead shared decision making discussions for patient care "

   }

   #============ New Updated EPA Definiation - from Logan Jones
   # EPA 1:  Split into two EPAs Below
   # EPA 1a Obtain a hypothesis-driven history
   # EPA 1b Perform a tailored physical examination
   # EPA 2: Generate a prioritized differential diagnosis for a clinical encounter  (Updated language)
   # EPA 3:   Interpret Diagnostic or Screening Tests  (Updated language)
   # EPA 4:   Enter orders including prescriptions.  (Updated language)
   # EPA 5:   Document a clinical encounter in the patient record  - Keep
   # EPA 6: Provide an oral presentation of a clinical encounter - Keep
   # EPA 7:  Use literature to make a patient care recommendation (Updated language)
   # EPA 8:  Communicate a patient handover to transition responsibility of care (Updated Language)
   # EPA 9:  Advance patient care through interprofessional collaboration  (Updated language)
   # EPA 10:  Recognize a patient requiring urgent assessment and escalate care  (Updated language)
   # EPA 11:  Lead Shared Decision Making Discussions For Patient Care (Updated language)
   # EPA 12: Perform general procedures of a physician  - REMOVED
   # EPA 13: Identify system failures and contribute to a culture of safety and improvement   REMOVED

   def hf_new_comp(rs_data, level)
     comp_hash = {}
     NEW_COMP_CODES.each do |comp|
       comp_hash[comp] = 0
     end
     rs_data.each do |rec|
       NEW_COMP_CODES.each do |comp|
         if rec[comp].to_s != ""
           #temp_level = rec[comp].to_s.split("~")
           if rec[comp] == level
             comp_hash[comp] += 1
           elsif level == 3 and rec[comp] > 3
             temp_val = rec[comp].to_f/3.0
             comp_hash[comp] = comp_hash[comp] + temp_val.round
           end
         end
       end
     end
     return comp_hash
   end

   def hf_average_comp_new (comp_hash3)
     percent_complete_hash = {}
     NEW_COMP_CODES.each do |comp|
       percent_complete_hash[comp] = 0.0
     end
     percent_complete = 0.0
     comp_hash3.each do |index, value|
       percent_complete = ((value.to_f/NEW_COMP_ASSESSORS[index])*100).round(0)
       if percent_complete >= 100
         percent_complete_hash[index] = 100
       else
         percent_complete_hash[index] = percent_complete
       end
     end
     return percent_complete_hash
   end

   def hf_load_all_new_competencies(rs_data, level)
     comp_hash = {}
     NEW_COMP_CODES.each do |comp|
       comp_hash[comp] = 0
     end
     rs_data.each do |rec|
       NEW_COMP_CODES.each do |comp|
         if rec[comp].to_s != ""
           #temp_level = rec[comp].split("~")
           if rec[comp] == level and check_clinical_comp2(rec["course_name"], level, comp)
             comp_hash[comp] += 1
           elsif level == 3 and rec[comp].to_i > 3
             temp_val = rec[comp].to_f/3.0
             comp_hash[comp] = comp_hash[comp] + temp_val.round
           end
         end
       end
     end
     #binding.pry
     return comp_hash
   end

   def hf_competency_new_class_mean(rs_data_unfiltered)
     courses = {}
     students_comp = {}
     temp_comp = []
     uniq_students = get_unique_student_id2(rs_data_unfiltered)
     uniq_students.each do |k, v|
       rs_courses = get_courses2(k["student_uid"], rs_data_unfiltered)
       comp_hash3 = hf_load_all_new_competencies(rs_courses, 3)
       ave_comp_per_student   = hf_average_comp_new(comp_hash3)
       students_comp[k["student_uid"]] = ave_comp_per_student
     end

     temp_comp_hash = {}
     NEW_COMP_CODES.each do |comp|
       temp_comp_hash[comp] = 0.0
     end
     students_comp.each do |k,v|
       v.each do |key, val|
         temp_comp_hash[key] += val
       end
     end
     class_mean_comp_hash = {}

     temp_comp_hash.each do |k,v|
       if students_comp.empty?
         class_mean_comp_hash[k] = 0
       elsif
           class_mean = (v/students_comp.count.to_f).round(0)
           if class_mean > 100
             class_mean_comp_hash[k] = 100
           else
             class_mean_comp_hash[k] = class_mean
           end
       end
     end
     return class_mean_comp_hash
   end

end
