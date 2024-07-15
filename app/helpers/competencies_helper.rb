module CompetenciesHelper

  COMP_CODES = ["ics1", "ics2", "ics3", "ics4", "ics5", "ics6", "ics7","ics8",
                "mk1", "mk2", "mk3", "mk4", "mk5",
                "pbli1", "pbli2", "pbli3", "pbli4", "pbli5", "pbli6", "pbli7", "pbli8",
                "pcp1", "pcp2", "pcp3", "pcp4", "pcp5", "pcp6",
                "pppd1", "pppd2", "pppd3", "pppd4", "pppd5", "pppd6", "pppd7", "pppd8", "pppd9", "pppd10", "pppd11",
                "sbpic1", "sbpic2", "sbpic3", "sbpic4", "sbpic5"]

  ASSESSORS2 = {  "ics1" => 6, "ics2" => 3, "ics3" => 3, "ics4" => 3, "ics5" => 7, "ics6" => 3, "ics7" => 3, "ics8" => 3,
                  "mk1" => 4, "mk2" => 6, "mk3" => 3, "mk4" => 3, "mk5" => 5,
                  "pbli1" => 8, "pbli2" => 4, "pbli3" => 3, "pbli4" => 4, "pbli5" => 3, "pbli6" => 3, "pbli7" => 3, "pbli8" => 3,
                  "pcp1" => 8, "pcp2" => 8, "pcp3" => 8, "pcp4" => 3, "pcp5" => 3, "pcp6" => 3,
                  "pppd1" => 6,"pppd2" => 4,"pppd3" => 3,"pppd4" => 3,"pppd5" => 3,"pppd6" => 3,"pppd7" => 3,"pppd8" => 3,"pppd9" => 8,"pppd10" => 6,"pppd11" => 3,
                  "sbpic1" => 3,"sbpic2" => 3,"sbpic3" => 3,"sbpic4" => 6,"sbpic5" => 3
  }

  COMP_CODES_CC = ["ics1", "ics2", "ics4", "ics5", "ics6", "ics7","ics8",
                   "pppd1", "pppd2", "pppd3", "pppd4", "pppd10", "pppd11",
                   "pbli3", "pbli6", "pbli8","pcp1",
                   "pcp2", "pcp3", "pcp4", "pcp5", "pcp6",
                   "sbpic3"]

   EPA = { "epa1" => ["pcp1", "ics1", "ics2", "ics3", "ics4", "pppd1", "pppd2", "pppd3", "pppd7", "pppd10", "sbpic3" ],
           "epa2" => ["pcp1", "pcp2", "pcp3", "mk1", "mk2", "mk3", "pbli1", "ics6", "pppd7", "pppd10", "pppd11", "sbpic3"],
           "epa3" => ["pcp2", "pcp3", "pcp4", "pcp5", "mk2", "mk3", "mk4", "mk5", "pbli3", "pbli4", "ics2", "pppd3", "pppd7", "pppd10", "sbpic2", "sbpic3" ],
           "epa4" => ["pcp3", "pcp4", "mk1", "mk2", "mk3", "pbli1", "pbli3", "pbli4", "ics1", "ics2", "pppd7", "pppd10", "sbpic2", "sbpic3"],
           "epa5" => ["pcp4", "mk5", "ics1", "ics2", "ics5", "ics6", "ics8", "pppd2", "pppd5", "pppd7", "pppd9", "pppd10", "sbpic1", "sbpic3", "sbpic4", "sbpic5"],
           "epa6" => ["pcp4", "pbli1", "pbli2", "ics1", "ics2", "ics6", "ics7", "ics8", "pppd2", "pppd4", "pppd7", "pppd10", "pppd11", "sbpic3", "sbpic4", "sbpic5"],
           "epa7" => ["mk1", "mk2", "mk3", "mk4", "mk5", "pbli1", "pbli2", "pbli3", "pbli4", "pbli5", "pppd7", "pppd10", "sbpic3" ],
           "epa8" => ["ics4", "ics5", "ics6", "ics7", "ics8", "pppd2", "pppd7", "pppd10", "sbpic3", "sbpic4", "sbpic5"],
           "epa9" => ["mk5", "ics3", "ics6", "pppd4", "pppd7", "pppd8", "pppd9", "pppd10", "sbpic3", "sbpic4", "sbpic5"],
           "epa10" => ["pcp1", "pcp2", "pcp3", "pcp4", "pcp6", "mk2", "ics3", "ics6", "ics8", "pppd3", "pppd4", "pppd6", "pppd7", "pppd10", "sbpic3", "sbpic5"],
           "epa11" => ["pcp4", "mk1", "mk2", "mk3", "ics1", "ics2", "ics3", "ics5", "pppd7", "pppd9", "pppd10", "sbpic2", "sbpic3"],
           "epa12" => ["pcp6", "ics1", "ics5", "pppd3", "pppd4", "pppd6", "pppd7", "pppd9", "pppd10", "sbpic3"],
           "epa13" => ["mk5", "pbli2", "pbli5", "pbli6", "pbli8", "ics1", "ics6", "pppd7", "pppd10", "sbpic1", "sbpic3", "sbpic5"]
   }

   EPA_DESC={"EPA1" => "Gather a history and perform a physical examination",
             "EPA2" => "Prioritize a differential diagnosis following a clinical encounter",
             "EPA3" => "Recommend and interpret common diagnostic and screening tests",
             "EPA4" => "Enter and discuss orders and prescriptions",
             "EPA5" => "Document a clinical encounter in the patient record",
             "EPA6" => "Provide an oral presentation of a clinical encounter",
             "EPA7" => "Form clinical questions and retrieve evidence to advance patient care",
             "EPA8" => "Give or receive a patient handover to transition care responsibility",
             "EPA9" => "Collaborate as a member of an interprofessional team",
             "EPA10" => "Recognize a patient requiring urgent or emergent care and initiate evaluation and management",
             "EPA11" => "Obtain informed consent for tests and/or procedures",
             "EPA12" => "Perform general procedures of a physician ",
             "EPA13" => "Identify system failures and contribute to a culture of safety and improvement"
   }

   COMP_DOMAIN_DESC = {
                       "ICS" => "Demonstrate interpersonal and communication skills that result in the effective exchange of information and collaboration with patients, their families, and health professionals.",
                       "MK" => "Demonstrate knowledge of established and evolving biomedical, clinical, epidemiological, and social-behavioral sciences, as well as the application of this knowledge to patient care.",
                       "PBLI" => "Demonstrate the ability to investigate and evaluate the care provided to patients, to appraise and assimilate scientific evidence, and to continuously improve patient care based on analysis of performance data, self-evaluation, and lifelong learning.",
                       "PCP" => "Provide patient-centered care that is compassionate, appropriate, and effective for the treatment of health problems and the promotion of health.",
                       "PPPD" => "Demonstrate a commitment to carrying out professional responsibilities, an adherence to ethical principles, and the qualities required to sustain lifelong personal and professional growth.",
                       "SBPIC" => "Demonstrate an awareness of and responsiveness to the larger context and system of healthcare, as well as the ability to effectively call upon other resources in the system to provide optimal care, including engaging in interprofessional teams in a manner that optimizes safe, effective patient and population-centered care."
   }

   COMP_DOMAIN = {  "ics"  => ["ics1", "ics2", "ics3", "ics4", "ics5", "ics6", "ics7", "ics8"],
                    "mk"   => ["mk1", "mk2", "mk3", "mk4", "mk5"],
                    "pbli" => ["pbli1", "pbli2", "pbli3", "pbli4", "pbli5", "pbli6", "pbli7", "pbli8"],
                    "pcp"  => ["pcp1", "pcp2", "pcp3", "pcp4", "pcp5", "pcp6"],
                    "pppd" => ["pppd1", "pppd2", "pppd3", "pppd4", "pppd5", "pppd6", "pppd7", "pppd8", "pppd9", "pppd10", "pppd11"],
                    "sbpic"=> ["sbpic1", "sbpic2", "sbpic3", "sbpic4", "sbpic5"]
   }

   DECODE_PRECEPTOR_COMP = { '1' => "Beginning",
                             '2' => "Effort",
                             '3' => "Threshold",
                             '4' => "Ready",
                             '888' => "Missing",
                             '' => "Missing"
                           }

   ATTRIBUTES_DEF = {
            'Attribute1' => "Did the student know their <B>limitations</B>, e.g. did they know what they did not know, ask for help when needed, etc.?",
            'Attribute1No' => "Please indicate how the student did not demonstrate this attribute.",
            'Attribute2' => "Was the student <B>truthful</B> (was there absence of deception in interactions with the preceptor, transparency of knowledge gaps or skills, or in the uncertainty regarding one's abilities)?",
            'Attribute2No' => "Please indicate how the student did not demonstrate this attribute.",
            'Attribute3' => "Was the student <B>conscientious</B> (did the student follow through with tasks especially in regard to consistency, resourcefulness and initiative)?",
            'Attribute3No' => "Please indicate how the student did not demonstrate this attribute.",
   }

   COMP_DESC = {   "PCP1" => "Gather essential and accurate information about patients and their conditions through history taking, physical examination, review of prior data and health records, laboratory data, imaging and other tests.",
                   "PCP2" => "Interpret and critically evaluate historical information, physical examination findings, laboratory data, imaging studies, and other tests required for health screening and diagnosis.",
                   "PCP3" => "Construct a prioritized differential diagnosis and make informed decisions about diagnostic and therapeutic interventions based on patient information and preferences, up-to-date scientific evidence, and clinical judgment.",
                   "PCP4" => "Develop, implement, and revise as indicated, patient management plans.",
                   "PCP5" => "Apply personalized healthcare services to patients, families, and communities aimed at preventing health problems and maintaining health.",
                   "PCP6" => "Perform all medical, diagnostic, and surgical procedures considered essential for the specific clinical practice context.",
                   "MK1" => "Apply established and emerging bio-medical scientific principles fundamental to the healthcare of patients and populations.",
                   "MK2" => "Apply established and emerging knowledge and principles of clinical sciences to diagnostic and therapeutic decision-making, clinical problem-solving and other aspects of evidence-based healthcare.",
                   "MK3" => "Apply principles of epidemiological sciences to the identification of health risk factors, prevention and treatment strategies, use of healthcare resources, and health promotion efforts for patients and populations.",
                   "MK4" => "Apply principles of social-behavioral sciences to assess the impact of psychosocial and cultural influences on health, disease, care-seeking, care-adherence, barriers to and attitudes toward care.",
                   "MK5" => "Apply principles of performance improvement, systems science, and science of health care delivery to the care of patients and populations.",
                   "PBLI1" => "Demonstrate skills necessary to support independent lifelong learning and ongoing professional development by identifying one’s own strengths, deficiencies, and limits in knowledge and expertise, set learning and improvement goals, and perform learning activities that address gaps in knowledge, skills or attitudes.",
                   "PBLI2" => "Participate in the education of peers and other healthcare professionals, students and trainees. ",
                   "PBLI3" => "Use clinical decision support tools to improve the care of patients and populations.",
                   "PBLI4" => "Use information technology to search, identify, and apply knowledge-based information to healthcare for patients and populations.",
                   "PBLI5" => "Continually identify, analyze, and implement new knowledge, guidelines, practice standards, technologies, products, and services that have been demonstrated to improve outcomes.",
                   "PBLI6" => "Analyze practice data using quality measurement tools and adjust clinical performance with the goal of improving patient outcomes and reducing errors.",
                   "PBLI7" => "Participate in scholarly activity thereby contributing to the creation, dissemination, application, and translation of new healthcare knowledge and practices. ",
                   "PBLI8" => "Incorporate feedback received from clinical performance data, patients, mentors, teachers, and colleagues into clinical practice to improve health outcomes.",
                   "ICS1" => "Communicate effectively with patients, families and the public, as appropriate, across a broad range of socioeconomic and cultural backgrounds.",
                   "ICS2" => "Counsel, educate and empower patients and their families to participate in their care and improve their health; enable shared decision-making; and engage patients through personal health records and patient health information access systems.",
                   "ICS3" => "Demonstrate insight and understanding about pain, emotions and human responses to disease states that allow one to develop rapport and manage interpersonal interactions.",
                   "ICS4" => "Use health information exchanges (e.g., Care Everywhere within the EPIC electronic health record) to identify and access patient information across clinical settings.",
                   "ICS5" => "Effectively access, review, and contribute to the electronic health record for patient care and other clinical activities.",
                   "ICS6" => "Effectively communicate with colleagues, other health professionals, and health related agencies in a responsive and responsible manner that supports the maintenance of health and the treatment of disease in individual patients and populations.",
                   "ICS7" => "Effectively communicate patient handoffs during transitions of care between providers or settings, and maintain continuity through follow-up on patient progress and outcomes.",
                   "ICS8" => "Act in a consultative role, including participation in the provision of clinical care remotely via telemedicine or other technology.",
                   "PPPD1" => "Demonstrate responsiveness to a diverse patient population, including but not limited to diversity in gender, age, culture, race, religion, disability, socioeconomic status, and sexual orientation.",
                   "PPPD2" => "Demonstrate respect for protected health information and safeguard patient privacy, security, and autonomy.",
                   "PPPD3" => "Demonstrate a commitment to ethical principles pertaining to provision or withholding of interventions, palliative care, confidentiality, informed consent, and business practices, including conflicts of interest, compliance with relevant laws, policies, and regulations.",
                   "PPPD4" => "Demonstrate sensitivity, honesty, and compassion in difficult conversations about issues such as death, end-of-life issues, adverse events, bad news, disclosure of errors, and other sensitive topics.",
                   "PPPD5" => "Adhere to professional standards when using information technology tools and electronic/social media.",
                   "PPPD6" => "Demonstrate responsiveness to patient needs that supersedes self-interest by mitigating conflict between personal and professional responsibilities.",
                   "PPPD7" => "Demonstrate awareness of one’s knowledge, skills, and emotional limitations and demonstrate healthy coping mechanisms and appropriate help-seeking behaviors.",
                   "PPPD8" => "Demonstrate integrity, establish oneself as a role model, and recognize and respond appropriately to unprofessional behavior or distress in professional colleagues.",
                   "PPPD9" => "Demonstrate accountability by completing academic and patient care responsibilities in a comprehensive and timely manner.",
                   "PPPD10" => "demonstrate trustworthiness that engenders trust in colleagues, patients, and society at large.",
                   "PPPD11" => "Recognize that ambiguity and uncertainty are part of clinical care and respond by demonstrating flexibility and an ability to modify one’s behavior.",
                   "SBPIC1" => "Participate in identifying system errors and implementing system solutions to improve patient safety.",
                   "SBPIC2" => "Incorporate considerations of resource allocation, cost awareness and risk-benefit analysis in patient and population-centered care.",
                   "SBPIC3" => "Demonstrate accountability to patients, society and the profession by fully engaging in patient care activities, and maintaining a sense of duty in the professional role of a physician.",
                   "SBPIC4" => "Effectively work with other healthcare professionals to establish and maintain a climate of mutual respect, dignity, diversity, integrity, honesty, and trust.",
                   "SBPIC5" => "Effectively work with other healthcare professionals as a member of an interprofessional team to provide patient care and population health management approaches that are coordinated, safe, timely, efficient, effective, and equitable."

   }

   BLOCK_COMP_DEF = {
     "Comp1" => "Weekly/Quizzes",
     "Comp2" => "Skills Assessments",
     "Comp3" => "OHSU Final Block Exam",
     "Comp4" => "NBME Exam",
     "Comp5" => "Final Skills Exam"
   }



  #==================================================================================================================================================================
  # New Competencies Mappings
  NEW_COMP_MAP ={
    "ics1" => "ics1", #
    "ics2" => "ics1", #
    "ics3" => "ics1", #
    "ics4" => "ics5", #
    "ics5" => "ics5", #
    "ics6" => "ics2", #
    "ics7" => "ics4", #
    "ics8" => "ics1", #

    "mk1" => "mk1",  # done with this category
    "mk2" => "mk2",
    "mk3" => "mk3",
    "mk4" => "mk2",
    "mk5" => "mk3",

    "pbli1" => "pbli1", #
    "pbli2" => "pbli3", #
    "pbli3" => "pbli2", #
    "pbli4" => "pbli2",  #
    "pbli5" => "pbli2", #
    "pbli6" => "pbli2", #
    "pbli7" => "pbli3", #
    "pbli8" => "pbli1",  #

    "pcp1" => "pcp1",  # done with this category
    "pcp2" => "pcp2",
    "pcp3" => "pcp2",
    "pcp4" => "pcp3",
    "pcp5" => "pcp3",
    "pcp6" => "pcp3",

    "pppd1" => "pppd1", #
    "pppd2" => "ics5",  #
    "pppd3" => "pppd1", #
    "pppd4" => "pppd1", #
    "pppd5" => "ics5",  #
    "pppd6" => "pppd2", #
    "pppd7" => "pbli1",  #
    "pppd8" => "pppd2", #
    "pppd9" => "pppd2", #
    "pppd10" => "pppd2", #
    "pppd11" => "pbli1", #

    "sbpic1" => "sbpic1",  # done with this item
    "sbpic2" => "sbpic1", # done with this item
    "sbpic3" => "pppd2", #
    "sbpic4" => "ics3", #
    "sbpic5" => "ics3" #
  }

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
    "pbli2" => 13,
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
    "pbli3" => "Engage in scholarly inquiry and disseminate findings using ethical principles.",
    "pcp1" => "Gather information through history and physical on patients.",
    "pcp2" => "Construct prioritized differential diagnosis based on interpretation of available clinical data.",
    "pcp3" => "Develop and implement a personalized management plan for the patient.",
    "pppd1" => "Identify and address the negative effects of structural and social determinants of health for patients with diverse needs.",
    "pppd2" => "Demonstrate behaviors that are reflective of professional values of truthfulness, timeliness, accountability, and follow through.",
    "sbpic1" => "Engage in the quality improvement process related to patient safety and system issues."

  }


  NEW_COMP_CODES = ["ics1", "ics2", "ics3", "ics4", "ics5", "mk1", "mk2", "mk3", "pbli1", "pbli2", "pbli3", "pcp1", "pcp2", "pcp3", "pppd1", "pppd2",  "sbpic1"]

  #===================================================================================================================================================================

  def hf_remap_comp(comp_hash3)
    new_comp = {}
    NEW_COMP_CODES.each do |comp|
      new_comp[comp] = 0
    end

    # comp_hash3.each do |key, value|
    #   puts "#{key} --> #{value}"
    # end
    comp_hash3.each do |key, value|
      new_comp[NEW_COMP_MAP[key]] = new_comp[NEW_COMP_MAP[key]] + value

    end

    # new_comp.each do |key, value|
    #   puts "new--> #{key} --> #{value}"
    # end

    return new_comp

  end

  def hf_comp_codes
    return COMP_CODES
  end

  def hf_get_block_comp_def (in_code)
    return BLOCK_COMP_DEF[in_code]
  end

  def hf_get_comp_def code
    return COMP_DESC[code]
  end

  def hf_get_archive_competency (user_id, permssion_group_id)
    if Med18Competency.table_exists? and !(comp = Med18Competency.where(user_id: user_id).order(start_date: :desc)).empty?
      return comp
    elsif Med19Competency.table_exists? and !(comp = Med19Competency.where(user_id: user_id).order(start_date: :desc)).empty?
      return comp
    elsif Med20Competency.table_exists? and !(comp = Med20Competency.where(user_id: user_id).order(start_date: :desc)).empty?
      return comp
    elsif Med21Competency.table_exists? and !(comp = Med21Competency.where(user_id: user_id).order(start_date: :desc)).empty?
      return comp
    else
      return nil
    end

  end

  def hf_total_count_comp(comp, code_arry=[])
    if comp.nil?
      return 0
    end
    tot_count = 0
    temp_arry = []
    code_arry.each do |code|
      temp_arry = comp.select{|c| c["course_name"] if c["course_name"].include? code }
      if !temp_arry.nil?
        tot_count += temp_arry.count
      end
    end
    return tot_count
  end

  def hf_attribute_def(in_key)
    if in_key.include? "Attribute"
      return ATTRIBUTES_DEF[in_key]
    else
      return "<b>" + in_key + "</b>"
    end

  end

  def hf_collect_values(hashes)
    h = Hash.new{|h,k| h[k]=[]}
    hashes.each_with_object(h) do |h, result|
      h.each{ |k, v| result[k] << v }
    end
    return h
  end

  def hf_decode_preceptor_comp2(in_code)
      return DECODE_PRECEPTOR_COMP[in_code]
  end

  def hf_comp_domain
    return COMP_DOMAIN_DESC
  end

  def hf_comp_domain_desc2(code)
    return COMP_DOMAIN_DESC["#{code}"]
  end

  def hf_epa_asessors
    return ASSESSORS2
  end

  def hf_get_epa_desc2 in_code
    return EPA_DESC["#{in_code}"]
  end

  def hf_final_grade2 json_str

    begin
      arry = JSON.parse(json_str)
      return arry["Grade"]
    rescue
      return json_str
    end
  end

  def hf_get_catalog(comp_code)

    long_str = ""
    courses = Course.select(:course_no, :course_name).where(competency_code: comp_code.upcase).limit(5)
    return "" if courses.empty?
    courses.each do |course|
      long_str += course.course_no + " - " + course.course_name + "<br>"
    end
    return long_str
  end

  def hf_get_courses(comp, in_code, in_level)
    courses  = comp.map{|key, val| key["course_name"] if key["#{in_code}"] == in_level or key["#{in_code}"] == 6 or key["#{in_code}"] == 9 or key["#{in_code}"] == 12 }.compact
    long_str = ""
    courses.sort.each do |course|
      long_str += course + "<br>"
    end
    return long_str
  end

  def hf_compute_domain_ave(comp_hash3, domain_comp_codes)
       ave_comp = hf_average_comp2 (comp_hash3)
       cnt = domain_comp_codes.count
       ave = 0
       total = 0
       domain_comp_codes.map!(&:downcase)
       domain_comp_codes.each do |code|
         total += ave_comp[code]
       end
       ave = (total.to_f/cnt).round(0)
       return ave
  end

  def hf_format_final_grade json_str
    begin
      grade_arry = JSON.parse(json_str)
      long_str = ""
      grade_arry.each do |key, val|
          long_str += "#{key.rjust(40)} -> #{val}<br />"
      end
      return   long_str
    rescue
      return json_str
    end
  end

  def hf_get_non_clinical_courses2
    non_clinical_courses_arry = []
    pathFile = File.join(Rails.root, 'public','non_clinical_courses.txt')
    non_clinical_courses_arry = IO.readlines(pathFile)
    non_clinical_courses_arry.map {|k| k.gsub!("\n", "")}
    return non_clinical_courses_arry
   end

    def hf_load_all_comp2(rs_data, level)
      comp_hash = {}
      COMP_CODES.each do |comp|
        comp_hash[comp] = 0
      end
      rs_data.each do |rec|
        COMP_CODES.each do |comp|
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
    #-----------------------------------------------
    # New competency code computation
    #------------------------------------------------
    def hf_average_comp2_remap (comp_hash3)
      percent_complete_hash = {}
      NEW_COMP_CODES.each do |comp|
        percent_complete_hash[comp] = 0
      end
      comp_hash3 = hf_remap_comp(comp_hash3)

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

    def hf_average_comp2 (comp_hash3)
      percent_complete_hash = {}
      COMP_CODES.each do |comp|
        percent_complete_hash[comp] = 0.0
      end
      percent_complete = 0.0
      comp_hash3.each do |index, value|
        percent_complete = ((value.to_f/ASSESSORS2[index])*100).round(0)
        if percent_complete >= 100
          percent_complete_hash[index] = 100
        else
          percent_complete_hash[index] = percent_complete
        end
      end
      return percent_complete_hash
    end

    def get_unique_student_id2 rs_data_unfiltered
      return rs_data_unfiltered.uniq{|e| e["student_uid"] }
    end

    def get_courses2(studentID, rs_data_unfiltered)
      return rs_data_unfiltered.select {|c| c["student_uid"] == studentID }
    end

    def check_clinical_comp2(in_course, in_level, in_comp_code)
      course_code = in_course.split("]")
      course_code[0] = course_code[0].gsub("[", "")
      if @non_clinical_course_arry.include?(course_code[0]) and in_level == "3" and COMP_CODES_CC.include?(in_comp_code)
          #puts "in_course: " + course_code[0] + " in_comp_code: " + in_comp_code + " level: " + in_level
          return false
      else
          return true
      end
    end

    def hf_load_all_competencies2(rs_data, level)
      comp_hash = {}
      COMP_CODES.each do |comp|
        comp_hash[comp] = 0
      end
      rs_data.each do |rec|
        COMP_CODES.each do |comp|
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

    def hf_competency_class_mean2_remap(rs_data_unfiltered)
      courses = {}
      students_comp = {}
      temp_comp = []
      uniq_students = get_unique_student_id2(rs_data_unfiltered)
      uniq_students.each do |k, v|
        rs_courses = get_courses2(k["student_uid"], rs_data_unfiltered)
        comp_hash3 = hf_load_all_competencies2(rs_courses, 3)
        ave_comp_per_student   = hf_average_comp2_remap(comp_hash3)
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
        class_mean = (v/students_comp.count.to_f).round(0)
        if class_mean > 100
          class_mean_comp_hash[k] = 100
        else
          class_mean_comp_hash[k] = class_mean
        end
      end
      return class_mean_comp_hash
    end

    def hf_competency_class_mean2(rs_data_unfiltered)
      courses = {}
      students_comp = {}
      temp_comp = []
      uniq_students = get_unique_student_id2(rs_data_unfiltered)
      uniq_students.each do |k, v|
        rs_courses = get_courses2(k["student_uid"], rs_data_unfiltered)
        comp_hash3 = hf_load_all_competencies2(rs_courses, 3)
        ave_comp_per_student   = hf_average_comp2(comp_hash3)
        students_comp[k["student_uid"]] = ave_comp_per_student
      end

      temp_comp_hash = {}
      COMP_CODES.each do |comp|
        temp_comp_hash[comp] = 0.0
      end
      students_comp.each do |k,v|
        v.each do |key, val|
          temp_comp_hash[key] += val
        end
      end
      class_mean_comp_hash = {}
      temp_comp_hash.each do |k,v|
        class_mean = (v/students_comp.count.to_f).round(0)
        if class_mean > 100
          class_mean_comp_hash[k] = 100
        else
          class_mean_comp_hash[k] = class_mean
        end
      end
      return class_mean_comp_hash
    end

    def hf_epa_level3_detail (rs_data, epa_id, level)
      epa = {}
      epa_code = "epa" + epa_id

      EPA[epa_code].each do |c|
        epa[c] = 0
      end

      rs_data.each do |rec|
        EPA[epa_code].each do |comp|
          if !rec[comp].nil?
            if (rec[comp] == level.to_i)
              epa[comp] += 1
            elsif rec[comp].to_i > 3
              temp_val = rec[comp].to_f/3.0
              epa[comp] = epa[comp] + temp_val.round
            end
          end
        end
      end
      return epa
    end

    def hf_epa_level(rs_data, epa_id, level)
      epa = {}
      epa_code = "epa" + epa_id

      EPA[epa_code].each do |c|
        epa[c] = 0
      end

      rs_data.each do |key, value|
        EPA[epa_code].each do |comp|
          if !value.nil?
            if (value == level.to_i) and (key==comp)
              epa[comp] += 1
            elsif value.to_i > 3 and (key==comp)
              temp_val = value.to_f/3.0
              epa[comp] = epa[comp] + temp_val.round
            end
          end
        end
      end
      return epa
    end

    def hf_epa2(comp_data)
      epa = {}
      for i in 1..13
         epa_code = "epa" + i.to_s
          temp_percent = 0
          EPA[epa_code].each do |c|
            temp_percent = temp_percent + comp_data[c]
          end
          epa[epa_code] = (temp_percent/EPA[epa_code].count.to_f).round(0)
      end
      return epa
    end

    def get_4_random_colors
      color_array = []
      for j in 0..12
        color_array.push "#" + "#{SecureRandom.hex(3)}"
      end
      return color_array
    end
    def domain_colors2 in_series
      temp_arry = []
      temp_data = {}
      for i in 0..4 do  # ICS
        temp_data = {y: in_series[i], color: '#BCD640'}
        temp_arry.push temp_data
      end
      for i in 5..7 do  # MK
        temp_data = {y: in_series[i], color: '#E09E51'}
        temp_arry.push temp_data
      end
      for i in 8..10 do  # PBLI
        temp_data = {y: in_series[i], color: '#C73293'}
        temp_arry.push temp_data
      end
      for i in 11..13 do  # PCP
        temp_data = {y: in_series[i], color: '#2C48DE'}
        temp_arry.push temp_data
      end
      for i in 14..15 do  # PPPD
        temp_data = {y: in_series[i], color: '#42D68D'}
        temp_arry.push temp_data
      end
      for i in 16..16 do  # SBPIC
        temp_data = {y: in_series[i], color: '#FF408F'}
        temp_arry.push temp_data
      end
      return temp_arry
    end

    def domain_colors in_series
      temp_arry = []
      temp_data = {}

      for i in 0..7 do  # ICS
        temp_data = {y: in_series[i], color: '#BCD640'}
        temp_arry.push temp_data
      end
      for i in 8..12 do  # MK
        temp_data = {y: in_series[i], color: '#E09E51'}
        temp_arry.push temp_data
      end
      for i in 13..20 do  # PBLI
        temp_data = {y: in_series[i], color: '#C73293'}
        temp_arry.push temp_data
      end
      for i in 21..26 do  # PCP
        temp_data = {y: in_series[i], color: '#2C48DE'}
        temp_arry.push temp_data
      end
      for i in 27..37 do  # PPPD
        temp_data = {y: in_series[i], color: '#42D68D'}
        temp_arry.push temp_data
      end
      for i in 38..42 do  # SBPIC
        temp_data = {y: in_series[i], color: '#FF408F'}
        temp_arry.push temp_data
      end

      return temp_arry
    end

    def hf_create_chart (type, series1, series2, student_name)
      data_series1 = series1.values
      data_series2 = series2.values
      categories = series2.keys.map{|c| c.upcase}

      if type == "EPA"
        title = "EPA"
      elsif type.include? "FoM"
        title = type
      elsif type.include? "New"
        data_series1 = domain_colors2(data_series1)
        title = "<b>New Competency (Working Progress!)</b>"
      else
        data_series1 = domain_colors(data_series1)
        title = "Competency"
      end

          chart = LazyHighCharts::HighChart.new('graph') do |f|
            f.title(text: "#{title} for " + "<i>#{student_name}" + '</i>'.html_safe)
            #f.subtitle(text: '<br />Total # of WBAs: <b>' + total_wba_count.to_s + '</b>')
            f.xAxis(categories: categories,
              labels: {
                  style:  {
                              fontWeight: 'bold',
                              color: '#000000'
                          }
                }
            )
            f.series(name: "#{student_name}", yAxis: 0, data: data_series1)
            if type != "EPA"
              f.series(name: "Class Mean", yAxis: 0, data: data_series2, type: 'scatter',
                color: 'black',
                marker: { symbol: 'diamond' })
            else
              f.series(name: "Class Mean", yAxis: 0, color: 'gray', data: data_series2)
            end
            # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
            f.colors(get_4_random_colors)

            f.yAxis [
               { max: 100,
                 min: 0,
                 tickInterval: 20,
                 title: {text: "<b>#{title} %", margin: 20}
               }
            ]
            f.plot_options(

              column: {
                  dataLabels: {
                      enabled: true,
                      crop: false,
                      overflow: 'none'
                  }
              },
              scatter: {
                  dataLabels: {
                      enabled: true,
                      crop: false,
                      overflow: 'none'
                  }
              },
              series: {
                cursor: 'pointer'

              }
            )

            f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0)
            f.chart({
                      defaultSeriesType: "column",
                      width: 1350, height:600,
                      plotBackgroundImage: ''
                    })
          end

          return chart
    end

   def check_series in_series
     temp_arry = []
     temp_data = {}
     in_series.each do |val|
       if val >= 70
         temp_arry.push val
       else
         temp_data = {y: val, color: '#FF4B44'}
         temp_arry.push temp_data
       end
     end
     return temp_arry
   end

    def hf_create_chart_fom (type, series1, series2, student_name, series_color)
      data_series1 = check_series(series1)
      data_series2 = series2
      categories = @category_labels
      if type.include? "Comp2" or type.include? "Comp5"
        categories = ["FUND-HSS", "FUND-BSS", "BLHD-HSS", "BLHD-BSS", "SBM-HSS", "SBM-BSS", "CPR-HSS", "CPR-BSS",  "HODI-HSS", "HODI-BSS", "NSF-HSS", "NSF-BSS", "DEVH-HSS" , "DEVH-BSS"]
        data_series1 = check_series(series1)
        data_series2 = series2
      end

        title = type

          chart = LazyHighCharts::HighChart.new('graph') do |f|
            f.title(text: "<b>#{title}" + "<br/>" + "#{student_name}" + '</b>' )
            #f.subtitle(text: '<br />Total # of WBAs: <b>' + total_wba_count.to_s + '</b>')
            f.xAxis(categories: categories,
              labels: {
                        style:  {
                                    fontWeight: 'bold',
                                    color: '#000000'
                                }
                      }
            )
            f.series(name: "#{student_name}", yAxis: 0, data: data_series1, color: series_color)
            f.series(name: "Class Mean", yAxis: 0, data: data_series2, type: 'scatter',
              color: 'black',
              marker: { symbol: 'diamond' })
            # ["#FA6735", "#3F0E82", "#1DA877", "#EF4E49"]
            f.colors(get_4_random_colors)

            f.yAxis [
               { max: 100,
                 min: 0,
                 tickInterval: 50,
                 title: {text: "<b>#{title} %", margin: 20}
               }
            ]
            f.plot_options(

              column: {
                  dataLabels: {
                      enabled: false,
                      crop: false,
                      overflow: 'none'
                  }
              },

              series: {
                cursor: 'pointer',
                pointWidth: 15

              }
            )

            f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0)
            f.chart({
                      defaultSeriesType: "column",
                      width: 580, height:300,
                      plotBackgroundImage: ''
                    })
          end

          return chart
    end

end
