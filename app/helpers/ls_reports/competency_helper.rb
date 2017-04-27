module LsReports::CompetencyHelper

  LEVEL1 = {
    'MK1-P' =>    'May remember and understand biophysical scientific principles but does not yet apply that knowledge to common medical and surgical conditions and basic preventive care. ',
    'MK2-P' =>    'May remember and understand clinical science principles but does not yet apply the knowledge to common medical and surgical conditions and basic preventive care. ',
    'MK3-P' =>    'May remember and understand epidemiologic principles but does not yet apply the knowledge to common medical and surgical conditions and basic preventive care. Inconsistently able to identify resources and recommend their use to help prevent common illnesses and promote health.',
    'MK4-P' =>    'Inconsistently considers the psychosocial and cultural influences on a patient\'s health and care plan.  May be able to recognize when a patient has not adhered to a prescribed care plan, but still developing skills to assist patients in identifying barriers to overcome challenges.',
    'MK5-P' =>    'Limited knowledge or experience with quality measurement and improvement, Plan-Do-Study-Act (PDSA) cycles and error reduction processes.  Limited ability to adequately interpret data related to performance measures such as run charts.  Limited knowledge or experience with the various elements of the health care system, taking a physician-centered approach to patient care. ',
    'PCP1-P'=>    'Either gathers too little information or exhaustively gathers information following a template, regardless of the patient\'s chief complaint, with each piece of information gathered seeming as important as the next. Recalls clinical information in the order elicited. Limited ability to gather, filter, prioritize, and connect pieces of information. Still developing skills to correctly perform and elicit physical examination maneuvers. Takes a head-to-toe approach to the physical examination rather than tailoring it to the developmental level or behavioral needs of the patient. Does not seek or is overly reliant on secondary data. ',
    'PCP2-P'=>    'Is inconsistent in interpreting basic diagnostic tests accurately. Still needs assistance with the concepts of pre-test probability and test-performance characteristics. ',
    'PCP3-P'=>    'Recalls and presents clinical facts in the history and physical in the order they were elicited without filtering, reorganization, or synthesis. Analytic reasoning through basic pathophysiology precludes pattern recognition and results in an exhaustive list of all diagnoses considered rather than the development of working diagnostic considerations, making it difficult to develop a therapeutic plan. The absence of a focused differential and working diagnosis also precludes incorporation of patient preferences into the diagnostic and management plan.',
    'PCP4-P'=>    'Develops and carries out management plans based on directives from others, either from the health care organization or the supervising physician. Does not routinely adjust plans based on individual patient differences or preferences. Communication about the plan is unidirectional, from the student to the patient/family. Inconsistently seeks additional guidance or consultation when needed. ',
    'PCP5-P'=>    'Less knowledgeable about health maintenance concepts.  Inconsistently performs patient-specific (e.g., based on patient age, gender, risk factors) screening procedures.  Answers patient\'s and families\' questions, but does not routinely offer anticipatory guidance.',
    'PCP6-P'=>    'Limited basic procedural skills including airway management, administration of universal precautions, and aseptic technique. Attempts, but has not yet mastered, listing indications, contraindications, anatomic landmarks, equipment, procedural technique, or potential risks and complications. ',
    'ICS1-P'=>    'Communication with patients and families generally unidirectional and based on a template. Still developing skills in varying the approach based on a patient\'s unique demographic, cognitive, physical, cultural, socioeconomic, or situational needs. Uses medical jargon. Still developing skills in engaging patients and families in discussions of care plans including shared decision making. Respects patient preferences when offered by the patient, but does not actively solicit preferences. Is uncomfortable or defers difficult conversations to other, more advanced members of the care team.',
    'ICS2-P'=>    'Conversations with patients and families contain medical jargon. Still developing skills in adjusting communication to a patient\'s specific circumstances. Defers discussion or questions with patients and families to other, more advanced team members. Defines a plan for the patient, rather than encouraging shared decision-making.',
    'ICS3-P'=>    'Still developing skills in anticipating or reading others\' emotions in verbal and nonverbal communication. Still developing skills in effectively managing strong emotions in self or others. ',
    'ICS4-P'=>    'Inconsistently seeks and retrieves patient data from outside health information systems.  May lack awareness of appropriate use of health information exchange systems such as Care Everywhere, immunization registries, and prescription drug monitoring program.',
    'ICS5-P'=>    'May neglect to review parts of the electronic health record database, or verify its accuracy with external sources.  May neglect to inform the team of electronic health record errors or omissions.  Documentation is in early development, and may be incomplete, or does not routinely include all important data and/or communicate clinical reasoning. Chooses templates without adequate alteration, possibly including no longer accurate or incorrect information.  Documentation may take an excessive amount of time to be finalized and submitted. . May be able to verbalize desired orders, but is not reliably able to pend accurate orders in the electronic health record.',
    'ICS6-P'=>    'May communicate using a template or prompt with rules-based recitation of facts. Communication does not change based on context, audience, or situation. Still developing skills in matching communication tool to situation (e.g., email, telephone, pager, texting, electronic health record [EHR], face-to-face).',
    'ICS7-P'=>    'Demonstrates variability in quality of transfer of information (content, accuracy, efficiency, and synthesis) during a handoff. Still developing skills in using available resources (e.g., information from EHR) to coordinate and ensure safe and effective patient care within and across delivery systems.',
    'ICS8-P'=>    'May choose to use telemedicine or technology in clinical scenarios where safety requires an in person consultation. May neglect to ensure that the patient/ consultant can hear/see/understand clearly. Still working on maintaining focus on the patient while using technology.  The addition of the technology interface may cause frustration or difficulty with making informed clinical recommendations.  ',
    'PPPD1-P'=>   'Sees the world through the eyes of his or her own background, may be ethnocentric, does not always seek to understand and/or accept the cultures of others. May generalize based on the patients\' gender, age, culture, race, religion, disabilities, and sexual orientation.',
    'PPPD2-P'=>   'Unintentionally compromises patient privacy and confidentiality such as discussing patient information in a public area (e.g., in an elevator) or accesses patient records for those not in their care. Still developing skills to protect patient privacy related to HIPAA. Still developing skills to solicit and incorporate patient preferences into practice.',
    'PPPD3-P'=>   'Has a basic understanding of ethical principles, formal policies and procedures, and does not intentionally disregard them, but does not apply them consistently to different ethical dilemmas. ',
    'PPPD4-P'=>   'Does not accurately anticipate or read others\' emotions in verbal and nonverbal communication. Is unaware of one\'s own emotional and behavioral cues and may transmit emotions in communication (e.g., anxiety, exuberance, and anger) that can precipitate unintended emotional responses in others. Does not effectively manage one\'s own strong emotions or those of others. ',
    'PPPD5-P'=>   'May unintentionally compromise patient confidentiality such as discussing cases in public areas.  Occasionally accesses patient information for those they are not giving care to, or may post information pertaining to patient encounters on social media. Does not routinely obtain consent prior to taking clinical pictures of patients. ',
    'PPPD6-P'=>   'Inconsistently demonstrates responsiveness to patient needs in favor of self-interests. May leave the clinical setting right at sign-out/last clinic patient regardless of whether care responsibilities are finished. Schedule requests may be common, excessive or inappropriate. ',
    'PPPD7-P'=>   'Can identify basic principles of physician wellness, but does not yet employ them consistently. Unclear of the boundaries of a student\'s scope of practice in clinical settings. May accept feedback from faculty and colleagues but does not readily seek it out. Inconsistently incorporates feedback provided. Reluctant to ask for help.  Ineffectively copes with stress inherent in medicine.',
    'PPPD8-P'=>   'May wear attire inappropriate for the clinical setting.  Occasional disrespectful interactions with patients or families, peers, and/or colleagues on the healthcare team.  Unaware or inconsistently aware of physician and colleague self-care and wellness. May recognize unprofessional behavior or distress in a colleague, but may not respond appropriately or mitigates the situation in a non-confidential, ineffectual, or inappropriate way.',
    'PPPD9-P'=>   'Patient care documentation and/or course assignments may take an excessive amount of time to be finalized and submitted. May complete assigned tasks in a timely manner but may need excessive reminders. Course requirements may be either partially complete or not finished. May skip conferences or have sporadic attendance.  ',
    'PPPD10-P'=>   'Demonstrates occasional lapses in professional conduct, such as through disrespectful interactions or lack of truth-telling, especially under conditions of stress or fatigue or in complicated or uncommon situations. This may put others in the position to remind, enforce, and resolve conflicts. There may be some insight into behavior, but learner is still developing skills to modify behavior when in stressful situations. ',
    'PPPD11-P'=>   'Uncomfortable when faced with uncertainty or ambiguity. Still developing skills in managing response to uncertainty. May be risk averse. May propose clinical or therapeutic options in black and white terms, rather than discussing a variety of options available to patients.  Inconsistently takes the patient\'s preferences into account.',
    'SBPIC1-P'=>   'Still developing skills in recognizing the potential for system error. May be defensive or blaming when encountering medical error. Uncomfortable with discussion of error or identification of the type of error. Approaches error prevention from an individual case, rather than a systems perspective. Often uses workarounds as a problem-solving strategy. ',
    'SBPIC2-P'=>   'Does not routinely consider cost in the evaluation and management of patients, including factors external to the system (e.g., socioeconomic, cultural, literacy, insurance status) and internal to the system (e.g., providers, suppliers, financers, purchasers). ',
    'SBPIC3-P'=>   'Appears to be interested in learning medicine but not fully engaged and involved as a professional, which results in a more observational or passive role.',
    'SBPIC4-P'=>   'Seeks answers and responds to authority from largely only intraprofessional colleagues. Does not routinely recognize other members of the interprofessional team as making significant contributions to the team. May dismiss input from professionals other than physicians. ',
    'SBPIC5-P'=>   'Limited participation in team discussion, passively follows the lead of others on the team. Does not routinely take initiative to interact with all team members. More focus on his or her own performance than other team members. ',
    'PBLI1-P'=>   'Relies on external prompts for understanding one\'s strengths, deficiencies, and limits. The learner acknowledges these external assessments, but understanding of performance is superficial and limited to the overall grade or bottom line; there is less understanding of how the performance measure relates in a meaningful way to the learner\'s specific level of knowledge, skills, and attitudes. Reflection and insight into performance and help-seeking is in development, but not yet mature. Sets learning and improvement goals that are overly broad and/or may not be connected to personal insight, accountability, and self-improvement.',
    'PBLI2-P'=>   'Limited or inconsistent attempts to provide evidence-based information to help peers and healthcare professionals understand any complex topics related to the practice of medicine.',
    'PBLI3-P'=>   'Lacks awareness of and inconsistently uses clinical decision support tools for patient management including drug-drug interaction checking, clinical alerts and preventive care reminders, patient data templates and order sets.',
    'PBLI4-P'=>   'Generally does not initiate attempts to use information technology without assignments and direct help. Unsure how to choose between multiple available databases for clinical query or for addressing learning needs. Does not routinely filter or prioritize the information retrieved, resulting in too much or not useful information. ',
    'PBLI5-P'=>   'Dependent on external direction to identify, analyze, and implement new knowledge, guidelines, standards, technologies, products, or services that have been demonstrated to improve outcomes. Sometimes reconsiders a new approach to a problem or seeks new information. Needs assistance to translate new medical information into patient care. Unfamiliar with critical appraisal in clinical research studies. ',
    'PBLI6-P'=>   'Still developing skills in reflection on practice. Limited understanding of quality reporting, types of quality measures, the principles of quality-improvement methodology or change management. Still developing skills to learn from the results of his or her practice. Still reliant on external prompts to inform and prioritize improvement opportunities at the population level.',
    'PBLI7-P'=>   'Limited or inconsistent attempts to conduct comprehensive literature searches for constructing relevant scholarly questions, or develop methods addressing gaps in the current field of knowledge. Still learning skills in effectively conveying how a proposed project will improve healthcare knowledge and/or practices.  May not actively contribute to the implementation of the project to address specific aims.  Unable to clearly communicate project rationale, methods, results, and conclusions to others.',
    'PBLI8-P'=>   'Receives feedback that is provided but still developing skills in solicitation of feedback. Limited incorporation of feedback into practice (e.g., through superficial or only transient change in behavior). '

  }

  LEVEL3 = {
    'MK1-E' => 'Possesses sufficient biophysical scientific knowledge and the ability to apply that required knowledge to common medical and surgical conditions and basic preventive care (e.g., can make a diagnosis, recommend initial management, and recognize variation in the presentation of common medical or surgical conditions). ',
    'MK2-E' => 'Possesses sufficient clinical science knowledge and the ability to apply that required knowledge to common medical and surgical conditions and basic preventive care (e.g., can make a diagnosis, recommend initial management, and recognize variation in the presentation of common medical and surgical conditions). ',
    'MK3-E' => 'Possesses sufficient knowledge of epidemiology and the ability to apply that required knowledge to common medical and surgical conditions and basic preventive care (e.g., can make a diagnosis and recommend initial management).  Able to identify resources and recommend their use to help prevent common illnesses and promote health. ',
    'MK4-E' => 'Routinely considers psychosocial and cultural influences on a patient\'s health and care plan.  Able assist patients having difficulty adhering to a treatment plan, helping them identify barriers and adapt plan that may address their challenges.  ',
    'MK5-E' => 'Articulates the value of standardization in reducing errors and applies this in caring for patients in clinical settings.  Uses measurement to understand the variance across the health care system. ',
    'PCP1-E'=> 'Clinical experience allows linkage of signs and symptoms of a current patient to those encountered in previous patients. When gathering information, is able to filter, prioritize, and synthesize it into pertinent positives and negatives as well as broad diagnostic categories. Performs basic physical examination maneuvers correctly and recognizes and correctly interprets abnormal findings. Consistently and successfully uses a developmentally appropriate approach to the physical examination. Seeks and obtains data from secondary sources when needed. ',
    'PCP2-E'=> 'Consistently interprets basic diagnostic tests accurately. Understands the concepts of pre-test probability and test-performance characteristics. ',
    'PCP3-E'=> 'Abstracts and reorganizes elicited clinical findings using semantic qualifiers (such as paired opposites that are used to describe clinical information [e.g., acute and chronic]) to compare and contrast the diagnoses being considered. The emergence of pattern recognition in diagnostic and therapeutic reasoning typically results in a well-synthesized and organized assessment of a focused differential diagnosis and management plan. The focused differential and working diagnosis allows incorporation of patient preferences into the diagnostic and management plan.',
    'PCP4-E'=> 'Develops and carries out management plans based on both theoretical knowledge and some experience, especially in managing common problems. Follows health care-institution practice guidelines and treatment algorithms as a matter of habit and good practice rather than as an externally imposed sanction. Plans begin to incorporate patients\' assumptions and values through more bidirectional communication, thus allowing for shared decision making. Consistently seeks additional guidance and consultation as needed. ',
    'PCP5-E'=> 'Has knowledge of health maintenance concepts.  Uses available resources and begins to seek new and current resources, guidelines, and recommendations for health promotion and disease prevention.  Usually performs patient-specific screening procedures.  Typically offers anticipatory guidance without prompting. Frequently identifies unhealthy behaviors and other risk factors during patient interactions and addresses those with the patient/family.',
    'PCP6-E'=> 'Demonstrates basic procedural skills including the administration of universal precautions and aseptic technique.  Consistently able to list indications, contraindications, anatomic landmarks, equipment, procedural technique, potential risks and complications in procedural notes. ',
    'ICS1-E'=> 'Communication with patients and families generally bidirectional. When based on a template, can adapt to the patient\'s unique demographic, cognitive, physical, cultural, socioeconomic, or situational needs. Avoids medical jargon. Uses a variety of techniques, including nontechnical language, teach back, appropriate pacing, and small pieces of information to ensure that communication with patients and their families is bidirectional and results in shared decision making. Is comfortable with even the most difficult communication scenarios. ',
    'ICS2-E'=> 'Engages in active listening to the patient/ family, allowing for the expression of caring, concern, and empathy. Maintains a respectful tone and rarely uses medical jargon. Assesses patient/family understanding. Recognizes that patients have varying circumstances and involves patient/family in shared decision making. ',
    'ICS3-E'=> 'Anticipates, reads, and reacts to emotions in real time with appropriate and professional behavior in typical medical communication scenarios, including those evoking very strong emotions. Uses these abilities to gain and maintain therapeutic alliances with others. ',
    'ICS4-E'=> 'Actively seeks and retrieves patient data from outside health information systems.  Recognizes appropriate use and limitations of health information exchange systems such as Care Everywhere, immunization registries, and prescription drug monitoring program.',
    'ICS5-E'=> 'Consistently reviews all parts of the electronic health record, verifying accuracy of the information as appropriate. Documentation is accurate and comprehensive and tailored to the specific situation. If used, templates are tailored to include only accurate and pertinent information.  Appropriately utilizes electronic health record data sets and consistently is able to pend accurate and appropriate orders.  Clinical reasoning is well documented. Documentation is completed and available in a timely fashion.',
    'ICS6-E'=> 'Successfully tailors communication strategy and message to the audience, purpose, and context in most situations. Fully aware of the purpose of the communication; can efficiently tell a story and provide rationale for decisions. Beginning to improvise in unfamiliar situations. Generally matches the communication tool to the situation.',
    'ICS7-E'=> 'Adapts and applies a standardized template, relevant to individual contexts, reliably and reproducibly during handoffs. Consistently uses available resources (e.g., information from EHR) to coordinate and ensure safe and effective patient care within and across delivery systems. Allows ample opportunity for clarification and questions. Occasionally anticipates potential issues for the recipient of the information.',
    'ICS8-E'=> 'Chooses clinical applications which are safe to use this form of technology. Ensures patients/consultants are able to see/hear/understand using the technology. Makes adjustments and acknowledges any distractions when necessary to accommodate for technologic issues. Does not allow the technology interface to distract the focus on the patient. Is able to make informed clinical recommendations using the technology interface.  ',
    'PPPD1-E'=>'Elicits and seeks to fully understand each patient\'s unique characteristics and needs based on gender, age, culture, race, religion, disabilities, and sexual orientation. Includes these concepts in care plans for patients and families. Families recognize this sensitivity. Demonstrates cultural humility.',
    'PPPD2-E'=>'Consistently maintains patient privacy and confidentiality related to HIPAA (e.g., only discusses patient care in private, secure environments). Accesses patient information in a secure manner and on appropriate patients.  Engages patients and families in discussions of care plans (i.e., shared decision making). Solicits and respects patient preferences.' ,
    'PPPD3-E'=>'Adheres to ethical principles and generally applies them consistently across ethical dilemmas. Follows formal policies and procedures. Acknowledges and limits conflict of interest. ',
    'PPPD4-E'=>'Anticipates, reads, and reacts to emotions in real time with appropriate and professional behavior in typical medical communication scenarios, including those evoking very strong emotions. Uses these abilities to gain and maintain therapeutic alliances with others. ',
    'PPPD5-E'=>'Maintains patient confidentiality. Accesses patient information in a secure manner and on appropriate patients.  Discusses patient care in private, secure environments. Responsibly and ethical use of social media, and does not use social media for any aspect of patient-related experiences.   Obtains proper consent for using any healthcare information whether it is de-identified or not.',
    'PPPD6-E'=>'Consistently responds to patient needs over fulfilling own self-interests.  Consistently ensures all patient care responsibilities are complete. Always demonstrates punctual attendance. Understands that being present and on-time is a crucial component of medical education and patient care and therefore limits absences/time-off requests to those that are absolutely unavoidable.',
    'PPPD7-E'=>'Identifies and employs basic principles of physician wellness. Consistently recognizes limits of knowledge and asks for assistance. Seeks constructive feedback from faculty members, colleagues and/or other members of the healthcare team. Consistently incorporates feedback. Seeks assistance and effectively copes with stress inherent in medicine.',
    'PPPD8-E'=>'Adheres to basic professional responsibilities such as timely reporting for duty rested and ready to work, and appropriate dress/grooming.  Is consistent in respectfully interacting with patients, families, peers, and colleagues on the healthcare team. Assists and responds to unprofessional colleagues or colleagues in distress in a professional and confidential manner. May promote programs for healthcare professional wellness.',
    'PPPD9-E'=>'Functions as a reliable member of the health care team. Punctual completion of patient care documentation and course assignments without reminders. Consistently attends conferences and other required course seminars or didactics. Is prepared to present patients when called upon. Follows through all tasks to completion.',
    'PPPD10-E'=>'In nearly all circumstances, demonstrates professional conduct, such as through respectful interactions and truth-telling. Has insight into his/her own behavior as well as likely triggers for professionalism lapses and is able to use this information to act in a professional manner.',
    'PPPD11-E'=>'Anticipates the likelihood of uncertainty at the time of diagnostic deliberation. Uses uncertainty as a prompt or motivation to seek information or understanding of what is unknown. Still struggles with balancing uncertainty and hope in discussions with patients and families, tending to err by emphasizing uncertainty, especially if risk averse (e.g., in diagnosis or prognosis).',
    'SBPIC1-E'=> 'Open to discussions of error. Actively identifies and reports medical error events and seeks to determine the type of error. Usually identifies the element of personal responsibility for individual or systems error corrections or solutions. Sees examination and analysis of error as an important part of the preventive process. ',
    'SBPIC2-E'=> 'Demonstrates understanding of external and internal factors related to cost. Critically appraises information available from an evaluation, test, or treatment to allow prioritization and optimization of cost and risk/benefit issues for an individual patient. Uses tools and information technology to support decision making and adopt strategies to decrease cost and risk to individuals. ',
    'SBPIC3-E'=> 'Demonstrates understanding and appreciation of the professional role and the gravity of being the "doctor" by becoming fully engaged in patient care activities. Has a sense of duty. Rarely lapses into behaviors that do not reflect a professional self-view. Demonstrates basic professional responsibilities such as appropriate dress/ grooming. ',
    'SBPIC4-E'=> 'Can articulate the unique contributions of other health care professionals. Seeks their input for appropriate issues and communicates their value to other members of the team and patients and families. As a result, is an excellent team player. ',
    'SBPIC5-E'=> 'Demonstrates an understanding of the roles of various team members by interacting with appropriate team members to accomplish assignments. Actively works to integrate into team function and understands the roles and responsibilities of all members of the team.',
    'PBLI1-E'=> 'Relies primarily on internal prompts for understanding one\'s strengths, deficiencies and limits through a process of reflection and insight. Reflection may be in response to uncertainty, discomfort, or tension in completing clinical duties; a critical incident; or suboptimal practice or outcomes. Recognizes limitations and has developed a personal value system of help-seeking for the sake of the patient that supersedes any perceived value of physician autonomy, resulting in appropriate requests for help when needed. Sets learning and improvement goals that are connected to personal insight, require personal accountability and prompt meaningful reflection upon achievement or non-achievement.',
    'PBLI2-E'=> 'Consistently provides evidence-based and factually correct information to help peers and healthcare professionals understand any complex topics related to the practice of medicine.',
    'PBLI3-E'=> 'Demonstrates awareness, appropriate use, and limitations of clinical decision support tools for patient management including drug-drug interaction checking, clinical alerts and preventive care reminders, patient data templates and order sets.  Tailors use of clinical decision support tools to specific clinical situation.',
    'PBLI4-E'=> 'Demonstrates a willingness to try new technology for patient care assignments or learning. Able to identify and use several available databases, search engines, or other appropriate tools, resulting in a manageable volume of information, most of which is relevant to the clinical question. Basic use of an electronic health record (EHR) is improving, as evidenced by greater efficacy and efficiency in performing needed tasks. Beginning to identify shortcuts to finding the right information quickly, such as using filters. Also avoids shortcuts that perpetuate incorrect information in the EHR. ',
    'PBLI5-E'=> 'Starts to take some initiative but dependent on the helps of others to identify, analyze, and implement new knowledge, guidelines, standards, technologies, products, or services that have been demonstrated to improve outcomes. Routinely reconsiders approaches to a problem or seeks new information. Can translate new medical information needs into patient care. Able to critically appraise a topic by analyzing the major outcomes; however, may need guidance in understanding the subtleties of the evidence.',
    'PBLI6-E'=> 'Able to reflect on practice with the aim of adjusting clinical performance to improve health outcomes.  Knowledgeable about types of quality measures, how these are calculated, and quality reporting.  Readily grasps improvement methodologies enough to actively participate in quality-improvement efforts to improve care of both individual patients and populations.',
    'PBLI7-E'=> 'Consistently able to systematically search the literature and develop relevant scholarly questions and, when appropriate, hypotheses. Can develop a feasible project that addresses the scholarly question(s), and can communicate how the project will improve healthcare knowledge and/or practices. Actively participates in the implementation of the project to address specific aims. Able to clearly communicate project rationale, methods and results to others, and synthesize how information learned will improve healthcare knowledge and/or practices.',
    'PBLI8-E'=> 'Regularly solicits feedback and engages in reflection. Internal sources of feedback allow for insight into limitations and engagement in self-regulation. Improves practice based on both external (solicited or unsolicited) feedback and internal insights (e.g., is able to point out what went well and what did not go well in a given encounter and makes positive changes in behavior as a result).'


  }

  COMP_DOMAIN_DESC = {    "ICS" => "Demonstrate interpersonal and communication skills that result in the effective exchange of information and collaboration with patients, their families, and health professionals.",
                          "MK" => "Demonstrate knowledge of established and evolving biomedical, clinical, epidemiological, and social-behavioral sciences, as well as the application of this knowledge to patient care.",
                          "PBLI" => "Demonstrate the ability to investigate and evaluate the care provided to patients, to appraise and assimilate scientific evidence, and to continuously improve patient care based on analysis of performance data, self-evaluation, and lifelong learning.",
                          "PCP" => "Provide patient-centered care that is compassionate, appropriate, and effective for the treatment of health problems and the promotion of health.",
                          "PPPD" => "Demonstrate a commitment to carrying out professional responsibilities, an adherence to ethical principles, and the qualities required to sustain lifelong personal and professional growth.",
                          "SBPIC" => "Demonstrate an awareness of and responsiveness to the larger context and system of healthcare, as well as the ability to effectively call upon other resources in the system to provide optimal care, including engaging in interprofessional teams in a manner that optimizes safe, effective patient and population-centered care."
  }

  COMP_DOMAIN = {  "ICS"  => ["ICS1", "ICS2", "ICS3", "ICS4", "ICS5", "ICS6", "ICS7", "ICS8"],
                   "MK"   => ["MK1", "MK2", "MK3", "MK4", "MK5"],
                   "PBLI" => ["PBLI1", "PBLI2", "PBLI3", "PBLI4", "PBLI5", "PBLI6", "PBLI7", "PBLI8"],
                   "PCP"  => ["PCP1", "PCP2", "PCP3", "PCP4", "PCP5", "PCP6"],
                   "PPPD" => ["PPPD1", "PPPD2", "PPPD3", "PPPD4", "PPPD5", "PPPD6", "PPPD7", "PPPD8", "PPPD9", "PPPD10", "PPPD11"],
                   "SBPIC"=> ["SBPIC1", "SBPIC2", "SBPIC3", "SBPIC4", "SBPIC5"]

  }


  COMP_DESC = {   "PCP1" => "1. Gather essential and accurate information about patients and their conditions through history taking, physical examination, review of prior data and health records, laboratory data, imaging and other tests.",
                  "PCP2" => "2. Interpret and critically evaluate historical information, physical examination findings, laboratory data, imaging studies, and other tests required for health screening and diagnosis.",
                  "PCP3" => "3. Construct a prioritized differential diagnosis and make informed decisions about diagnostic and therapeutic interventions based on patient information and preferences, up-to-date scientific evidence, and clinical judgment.",
                  "PCP4" => "4. Develop, implement, and revise as indicated, patient management plans.",
                  "PCP5" => "5. Apply personalized healthcare services to patients, families, and communities aimed at preventing health problems and maintaining health.",
                  "PCP6" => "6. Perform all medical, diagnostic, and surgical procedures considered essential for the specific clinical practice context.",
                  "MK1" => "1. Apply established and emerging bio-medical scientific principles fundamental to the healthcare of patients and populations.",
                  "MK2" => "2. Apply established and emerging knowledge and principles of clinical sciences to diagnostic and therapeutic decision-making, clinical problem-solving and other aspects of evidence-based healthcare.",
                  "MK3" => "3. Apply principles of epidemiological sciences to the identification of health risk factors, prevention and treatment strategies, use of healthcare resources, and health promotion efforts for patients and populations.",
                  "MK4" => "4. Apply principles of social-behavioral sciences to assess the impact of psychosocial and cultural influences on health, disease, care-seeking, care-adherence, barriers to and attitudes toward care.",
                  "MK5" => "5. Apply principles of performance improvement, systems science, and science of health care delivery to the care of patients and populations.",
                  "PBLI1" => "1. Demonstrate skills necessary to support independent lifelong learning and ongoing professional development by identifying one’s own strengths, deficiencies, and limits in knowledge and expertise, set learning and improvement goals, and perform learning activities that address gaps in knowledge, skills or attitudes.",
                  "PBLI2" => "2. Participate in the education of peers and other healthcare professionals, students and trainees. ",
                  "PBLI3" => "3. Use clinical decision support tools to improve the care of patients and populations.",
                  "PBLI4" => "4. Use information technology to search, identify, and apply knowledge-based information to healthcare for patients and populations.",
                  "PBLI5" => "5. Continually identify, analyze, and implement new knowledge, guidelines, practice standards, technologies, products, and services that have been demonstrated to improve outcomes.",
                  "PBLI6" => "6. Analyze practice data using quality measurement tools and adjust clinical performance with the goal of improving patient outcomes and reducing errors.",
                  "PBLI7" => "7. Participate in scholarly activity thereby contributing to the creation, dissemination, application, and translation of new healthcare knowledge and practices. ",
                  "PBLI8" => "8. Incorporate feedback received from clinical performance data, patients, mentors, teachers, and colleagues into clinical practice to improve health outcomes.",
                  "ICS1" => "1. Communicate effectively with patients, families and the public, as appropriate, across a broad range of socioeconomic and cultural backgrounds.",
                  "ICS2" => "2. Counsel, educate and empower patients and their families to participate in their care and improve their health; enable shared decision-making; and engage patients through personal health records and patient health information access systems.",
                  "ICS3" => "3. Demonstrate insight and understanding about pain, emotions and human responses to disease states that allow one to develop rapport and manage interpersonal interactions.",
                  "ICS4" => "4. Use health information exchanges (e.g., Care Everywhere within the EPIC electronic health record) to identify and access patient information across clinical settings.",
                  "ICS5" => "5. Effectively access, review, and contribute to the electronic health record for patient care and other clinical activities.",
                  "ICS6" => "6. Effectively communicate with colleagues, other health professionals, and health related agencies in a responsive and responsible manner that supports the maintenance of health and the treatment of disease in individual patients and populations.",
                  "ICS7" => "7. Effectively communicate patient handoffs during transitions of care between providers or settings, and maintain continuity through follow-up on patient progress and outcomes.",
                  "ICS8" => "8. Act in a consultative role, including participation in the provision of clinical care remotely via telemedicine or other technology.",
                  "PPPD1" => "1. Demonstrate responsiveness to a diverse patient population, including but not limited to diversity in gender, age, culture, race, religion, disability, socioeconomic status, and sexual orientation.",
                  "PPPD2" => "2. Demonstrate respect for protected health information and safeguard patient privacy, security, and autonomy.",
                  "PPPD3" => "3. Demonstrate a commitment to ethical principles pertaining to provision or withholding of interventions, palliative care, confidentiality, informed consent, and business practices, including conflicts of interest, compliance with relevant laws, policies, and regulations.",
                  "PPPD4" => "4. Demonstrate sensitivity, honesty, and compassion in difficult conversations about issues such as death, end-of-life issues, adverse events, bad news, disclosure of errors, and other sensitive topics.",
                  "PPPD5" => "5. Adhere to professional standards when using information technology tools and electronic/social media.",
                  "PPPD6" => "6. Demonstrate responsiveness to patient needs that supersedes self-interest by mitigating conflict between personal and professional responsibilities.",
                  "PPPD7" => "7. Demonstrate awareness of one’s knowledge, skills, and emotional limitations and demonstrate healthy coping mechanisms and appropriate help-seeking behaviors.",
                  "PPPD8" => "8. Demonstrate integrity, establish oneself as a role model, and recognize and respond appropriately to unprofessional behavior or distress in professional colleagues.",
                  "PPPD9" => "9. Demonstrate accountability by completing academic and patient care responsibilities in a comprehensive and timely manner.",
                  "PPPD10" => "10. demonstrate trustworthiness that engenders trust in colleagues, patients, and society at large.",
                  "PPPD11" => "11. Recognize that ambiguity and uncertainty are part of clinical care and respond by demonstrating flexibility and an ability to modify one’s behavior.",
                  "SBPIC1" => "1. Participate in identifying system errors and implementing system solutions to improve patient safety.",
                  "SBPIC2" => "2. Incorporate considerations of resource allocation, cost awareness and risk-benefit analysis in patient and population-centered care.",
                  "SBPIC3" => "3. Demonstrate accountability to patients, society and the profession by fully engaging in patient care activities, and maintaining a sense of duty in the professional role of a physician.",
                  "SBPIC4" => "4. Effectively work with other healthcare professionals to establish and maintain a climate of mutual respect, dignity, diversity, integrity, honesty, and trust.",
                  "SBPIC5" => "5. Effectively work with other healthcare professionals as a member of an interprofessional team to provide patient care and population health management approaches that are coordinated, safe, timely, efficient, effective, and equitable."

  }


  COMP_CODES = ["ICS1", "ICS2", "ICS3", "ICS4", "ICS5", "ICS6", "ICS7","ICS8",
                "MK1", "MK2", "MK3", "MK4", "MK5",
                "PBLI1", "PBLI2", "PBLI3", "PBLI4", "PBLI5", "PBLI6", "PBLI7", "PBLI8",
                "PCP1", "PCP2", "PCP3", "PCP4", "PCP5", "PCP6",
                "PPPD1", "PPPD2", "PPPD3", "PPPD4", "PPPD5", "PPPD6", "PPPD7", "PPPD8", "PPPD9", "PPPD10", "PPPD11",
                "SBPIC1", "SBPIC2", "SBPIC3", "SBPIC4", "SBPIC5"]

  ASSESSORS = {   "ICS1" => 6, "ICS2" => 3, "ICS3" => 3, "ICS4" => 3, "ICS5" => 7, "ICS6" => 3, "ICS7" => 3, "ICS8" => 3,
                  "MK1" => 4, "MK2" => 6, "MK3" => 3, "MK4" => 3, "MK5" => 5,
                  "PBLI1" => 8, "PBLI2" => 4, "PBLI3" => 3, "PBLI4" => 4, "PBLI5" => 3, "PBLI6" => 3, "PBLI7" => 3, "PBLI8" => 3,
                  "PCP1" => 8, "PCP2" => 8, "PCP3" => 8, "PCP4" => 3, "PCP5" => 3, "PCP6" => 3,
                  "PPPD1" => 6,"PPPD2" => 4,"PPPD3" => 3,"PPPD4" => 3,"PPPD5" => 3,"PPPD6" => 3,"PPPD7" => 3,"PPPD8" => 3,"PPPD9" => 8,"PPPD10" => 6,"PPPD11" => 3,
                  "SBPIC1" => 3,"SBPIC2" => 3,"SBPIC3" => 3,"SBPIC4" => 6,"SBPIC5" => 3
  }

  EPA = { "EPA1" => ["PCP1", "ICS1", "ICS2", "ICS3", "ICS4", "PPPD1", "PPPD2", "PPPD3", "PPPD7", "PPPD10", "SBPIC3" ],
          "EPA2" => ["PCP1", "PCP2", "PCP3", "MK1", "MK2", "MK3", "PBLI1", "ICS6", "PPPD7", "PPPD10", "PPPD11", "SBPIC3"],
          "EPA3" => ["PCP2", "PCP3", "PCP4", "PCP5", "MK2", "MK3", "MK4", "MK5", "PBLI3", "PBLI4", "ICS2", "PPPD3", "PPPD7", "PPPD10", "SBPIC2", "SBPIC3" ],
          "EPA4" => ["PCP3", "PCP4", "MK1", "MK2", "MK3", "PBLI1", "PBLI3", "PBLI4", "ICS1", "ICS2", "PPPD7", "PPPD10", "SBPIC2", "SBPIC3"],
          "EPA5" => ["PCP4", "MK5", "ICS1", "ICS2", "ICS5", "ICS6", "ICS8", "PPPD2", "PPPD5", "PPPD7", "PPPD9", "PPPD10", "SBPIC1", "SBPIC3", "SBPIC4", "SBPIC5"],
          "EPA6" => ["PCP4", "PBLI1", "PBLI2", "ICS1", "ICS2", "ICS6", "ICS7", "ICS8", "PPPD2", "PPPD4", "PPPD7", "PPPD10", "PPPD11", "SBPIC3", "SBPIC4", "SBPIC5"],
          "EPA7" => ["MK1", "MK2", "MK3", "MK4", "MK5", "PBLI1", "PBLI2", "PBLI3", "PBLI4", "PBLI5", "PPPD7", "PPPD10", "SBPIC3" ],
          "EPA8" => ["ICS4", "ICS5", "ICS6", "ICS7", "ICS8", "PPPD2", "PPPD7", "PPPD10", "SBPIC3", "SBPIC4", "SBPIC5"],
          "EPA9" => ["MK5", "ICS3", "ICS6", "PPPD4", "PPPD7", "PPPD8", "PPPD9", "PPPD10", "SBPIC3", "SBPIC4", "SBPIC5"],
          "EPA10" => ["PCP1", "PCP2", "PCP3", "PCP4", "PCP6", "MK2", "ICS3", "ICS6", "ICS8", "PPPD3", "PPPD4", "PPPD6", "PPPD7", "PPPD10", "SBPIC3", "SBPIC5"],
          "EPA11" => ["PCP4", "MK1", "MK2", "MK3", "ICS1", "ICS2", "ICS3", "ICS5", "PPPD7", "PPPD9", "PPPD10", "SBPIC2", "SBPIC3"],
          "EPA12" => ["PCP6", "ICS1", "ICS5", "PPPD3", "PPPD4", "PPPD6", "PPPD7", "PPPD9", "PPPD10", "SBPIC3"],
          "EPA13" => ["MK5", "PBLI2", "PBLI5", "PBLI6", "PBLI8", "ICS1", "ICS6", "PPPD7", "PPPD10", "SBPIC1", "SBPIC3", "SBPIC5"]
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

  TOTAL_COMPETENCIES = 43
  TOTAL_DOMAINS = 6

  def hf_comp_type(level)
    case level
    when "0" then return ""
    when "1" then return "-P"
    when "2" then return ""
    when "3" then return "-E"
    else
      return ""
    end
  end

  def hf_comp_domain_desc
    comp_domain_desc = COMP_DOMAIN_DESC
  end

  def hf_comp_domain
    comp_domain = COMP_DOMAIN
  end

  def hf_all_comp_codes
    return COMP_CODES
  end

  def hf_load_all_competencies(rs_data, level)
    comp_hash = {}
    COMP_CODES.each do |comp|
      comp_hash[comp] = 0
    end
    rs_data.each do |rec|
      COMP_CODES.each do |comp|
        if !rec[comp].nil?
          temp_level = rec[comp].split("~")
          if temp_level[0] == level
            comp_hash[comp] += 1
          elsif level == "3" and temp_level[0].to_i > 3
            temp_val = temp_level[0].to_f/3.0
            comp_hash[comp] = comp_hash[comp] + temp_val.round
          end
        end
      end
    end

    #binding.pry
    return comp_hash
  end

  def hf_comp_courses(rs_data, level)
    competency_courses = {}
    COMP_CODES.each do |comp|
      competency_courses[comp] = ''
    end

    rs_data.each do |rec|
      COMP_CODES.each do |comp|
        if !rec[comp].nil?
          temp_level = rec[comp].split("~")
          if temp_level[0] == level
            competency_courses[comp] << rec["CourseName"] << "~" << rec["CourseID"] << ", "
            # need to check for 2, 1, 0 codes - to figure how many times a student had encountered these experiences
          elsif level == "3" and temp_level[0].to_i > 3 ## contains FoM - Pre-clinical courses
            competency_courses[comp] << rec["CourseName"] << "~" << rec["CourseID"] << ", "
          end
        end
      end
    end
    return competency_courses
  end

  def hf_average_comp (comp_hash3)
    percent_complete_hash = {}
    COMP_CODES.each do |comp|
      percent_complete_hash[comp] = 0.0
    end

    percent_complete = 0.0

    comp_hash3.each do |index, value|
      percent_complete = ((value.to_f/ASSESSORS[index])*100).round(0)
      if percent_complete >= 100
        percent_complete_hash[index] = 100
      else
        percent_complete_hash[index] = percent_complete
      end

    end

    return percent_complete_hash
  end

  def hf_average_domain(comp_hash, comp_code)
    ave = 0.0
    total_ent = 0.00
    temp_percent = 0.00
    no_of_comp = 0
    comp_hash.each do |index, value|
      if index.include?(comp_code)
        no_of_comp += 1
        temp_percent = value.to_f/ASSESSORS[index]
        if temp_percent >= 1.0
          total_ent += 1.0
        else
          total_ent += temp_percent
        end
      end
    end

    ave = ((total_ent/no_of_comp)*100).round(0)
    if ave >= 100
      return ave = 100
    else
      return ave
    end
  end

  def hf_competency_class_mean(rs_data_unfiltered)
    courses = {}
    students_comp = {}
    temp_comp = []
    uniq_students = get_unique_medhub_id(rs_data_unfiltered)
    uniq_students.each do |k, v|
      rs_courses = get_courses(k["MedhubID"], rs_data_unfiltered)
      comp_hash3 = hf_load_all_competencies(rs_courses, "3")
      ave_comp_per_student   = hf_average_comp(comp_hash3)
      students_comp[k["MedhubID"]] = ave_comp_per_student
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

  #------------------------------------------------------------------------

  def hf_get_epa_desc epa_code
    ret_desc = "<table border=1 CELLPADDING=3 CELLSPACING=1 RULES=COLS FRAME=VSIDES ><tr><td>" +
      "<b>#{epa_code} - </b> #{EPA_DESC[epa_code]}</td></tr></table>"
    return ret_desc
  end


  def hf_has_epa? rs_question
    #if parent_question.question.include? "Level 1"
    comp_code = rs_question.question

    if LEVEL1[comp_code]
      return true
    elsif LEVEL3[comp_code]
      return true
    else
      return false
    end
  end

  def hf_get_comp_desc rs_question

    comp_code = rs_question.question
    if LEVEL1[comp_code]
      # comp_code contains "-P", need to replace it with "-E" as we display the desc side by side.
      e_code = comp_code.split("-").first + "-E"
      ret_desc = "<table border=1 CELLPADDING=3 CELLSPACING=1 RULES=COLS FRAME=VSIDES ><tr><td><b>#{comp_code}</b> #{LEVEL1[comp_code]}</td><td>" +
        "<b>#{e_code}</b> #{LEVEL3[e_code]}</td></tr></table>"

      rs_question.question = comp_code.split("-").first
      return ret_desc
    end
    if  LEVEL3[comp_code]
      rs_question.question = comp_code.split("-").first
      return LEVEL3[comp_code]
    end
  end

  def hf_get_comp_desc2 in_code

    comp_code = in_code
    if LEVEL1[comp_code]
      # comp_code contains "-P", need to replace it with "-E" as we display the desc side by side.
      e_code = comp_code.split("-").first + "-E"
      ret_desc = "<table border=1 CELLPADDING=3 CELLSPACING=1 RULES=COLS FRAME=VSIDES ><tr><td><b>#{comp_code}</b> #{LEVEL1[comp_code]}</td><td>" +
        "<b>#{e_code}</b> #{LEVEL3[e_code]}</td></tr></table>"
      return ret_desc
    end
    if  LEVEL3[comp_code]
      return LEVEL3[comp_code]
    end
  end

  def hf_total_competency in_comp
    total_comp = 0
    COMP_CODES.each do |c|
      if !in_comp[c].nil?
        total_comp += 1
      end
    end
    return total_comp
  end

  # level = "0", "1", '2', "3"

  def hf_total_level(in_comp,level)
    total_level = 0
    COMP_CODES.each do |c|
      if !in_comp[c].nil?
        temp_level = in_comp[c].split("~")
        if temp_level[0] == level
          total_level += 1
        elsif level == "3" and temp_level[0].to_i > 3
          temp_val = temp_level[0].to_f/3.0
          total_level = total_level + temp_val.round
        end
      end
    end
    return total_level
  end

  def hf_level_comp_codes(in_comp, level)
    level_comp_codes = []
    COMP_CODES.each do |c|
      if !in_comp[c].nil?
        temp_level = in_comp[c].split("~")
        if temp_level[0] == level
          level_comp_codes.push c
        elsif level == "3" and temp_level[0] > "3"  ## load FoM - pre-clinical competencies
          level_comp_codes.push c
        end
      end
    end
    return level_comp_codes
  end

  def hf_epa(rs_data, epa_id, level)
    epa = {}
    epa_code = "EPA" + epa_id

    EPA[epa_code].each do |c|
      epa[c] = 0
    end

    rs_data.each do |rec|
      EPA[epa_code].each do |comp|
        if !rec[comp].nil?
          temp_level = rec[comp].split("~")
          if temp_level[0] == level
            epa[comp] += 1
          elsif level == "3" and temp_level[0].to_i > 3
            temp_val = temp_level[0].to_f/3.0
            epa[comp] = epa[comp] + temp_val.round
          end
        end
      end
    end
    return epa
  end

  def hf_epa_courses(rs_data, epa_id, level)
    epa_courses = {}
    epa_code = "EPA" + epa_id

    EPA[epa_code].each do |c|
      epa_courses[c] = ''
    end

    rs_data.each do |rec|
      EPA[epa_code].each do |comp|
        if !rec[comp].nil?
          temp_level = rec[comp].split("~")
          if temp_level[0] == level
            epa_courses[comp] << rec["CourseName"] << "~" << rec["CourseID"] << ", "
          elsif level == "3" and temp_level[0] > "3"  ## load FoM records
            epa_courses[comp] << rec["CourseName"] << "~" << rec["CourseID"] << ", "
          end
        end
      end
    end
    return epa_courses
  end

  def hf_course_desc(in_course_desc)
    temp_desc = in_course_desc.split("~")
    return temp_desc[0]
  end

  def hf_average_epa epa
    ave = 0.0
    total_ent = 0.00
    total_assess = 0.00
    temp_percent = 0.00
    epa.each do |index, value|
      temp_percent = value.to_f/ASSESSORS[index]
      if temp_percent >= 1.0
        total_ent += 1.0
      else
        total_ent += temp_percent
      end
    end

    ave = ((total_ent/epa.count)*100).round(0)
    #ave = ((total_ent/total_assess)*100).round(0)
    if ave >= 100
      return ave = 100
    else
      return ave
    end
  end

  def hf_all_average_epas rs_data
    overall_ave_epa = 0
    total_ave = 0
    ave = 0
    for i in 1..13
      epa = hf_epa(rs_data, i.to_s, "3")
      ave = hf_average_epa epa
      total_ave += ave
    end
    #TOTAL EPA = 13
    overall_ave_epa = (total_ave/13).round(0)
    return overall_ave_epa
  end

  def hf_display_epa_detail epa
    temp_epa = ""
    epa.each do |k, v|
      temp_epa << "#{k}=#{v}, "
    end

    return temp_epa[0...-2]  # remove the last char, ","
  end

  def hf_epa_desc
    return EPA_DESC
  end

  def hf_assessors
    return ASSESSORS
  end

  def get_unique_medhub_id rs_data_unfiltered
    return rs_data_unfiltered.uniq{|e| e["MedhubID"] }
  end

  def get_courses(medhubID, rs_data_unfiltered)
    return rs_data_unfiltered.select {|c| c["MedhubID"] == medhubID }
  end

  def hf_get_complete courses
    overall_epa_complete = 0
    total_complete = 0
    complete = 0
    student_epa = []

    for i in 1..13
      epa = hf_epa(courses, i.to_s, "3")
      complete = hf_average_epa epa
      total_complete += complete
      student_epa[i] = complete
    end

    #TOTAL EPA = 13
    overall_epa_complete = (total_complete/13).round(0)
    student_epa[0] = overall_epa_complete
    return student_epa
  end

  def hf_epa_class_mean(rs_data_unfiltered)
    courses = {}
    students_epa = {}
    temp_epa = []
    uniq_students = get_unique_medhub_id(rs_data_unfiltered)
    uniq_students.each do |k, v|
      courses = get_courses(k["MedhubID"], rs_data_unfiltered)
      temp_epa = hf_get_complete(courses)
      students_epa[k["MedhubID"]] = temp_epa
    end
    total_epa = Array.new(14,0)
    class_mean_epa = []
    students_epa.values.each do |v|
      v.each_with_index do |x, idx|
        total_epa[idx] += x
      end
    end
    for i in 0..13
      class_mean_epa[i] = (total_epa[i]/students_epa.count.to_f).round(0)
    end
    return class_mean_epa
  end
end
