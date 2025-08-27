class Student < ApplicationRecord

  def self.execute_sql(*sql_array)
    connection.execute(sanitize_sql_array(sql_array))
  end

  def self.specialties
    ["Anesthesiology",
    "Child Neurology",
    "Dermatology",
    "Diagnostic Radiology",
    "Emergency Medicine",
    "Family Medicine",
    "General Surgery",
    "Internal Medicine",
    "Internal Medicine/Pediatrics",
    "Intervention Radiology",
    "Neurological Surgery",
    "Neurology",
    "Obstetrics & Gynecology",
    "Ophthalmology",
    "Orthopedic Surgery",
    "Otolaryngology",
    "Pathology",
    "Pediatrics",
    "Physical Medicine & Rehabilitation",
    "Plastic Surgery",
    "Preliminary Year-Surgery",
    "Preventive Surgery",
    "Preventive Medicine",
    "Psychiatry",
    "Radiation Oncology",
    "Thoracic Surgery",
    "Transition Year",
    "Urology",
    "Vascular Surgery",
    "Other - Please Specify"]
  end
end
