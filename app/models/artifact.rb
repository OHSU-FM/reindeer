class Artifact < ApplicationRecord
  belongs_to :user
  has_many_attached :documents
  # Note that implicit association has a plural form in this case
  scope :with_eager_loaded_images, -> { eager_load(images_attachments: :blob) }

  validates :documents, presence: true, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'application/pdf', 'application/csv', 'application/x-csv',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'text/plain', 'text/csv'], size_range: 1..10.megabytes }

    COMP_CODES = ["ics1", "ics2", "ics3", "ics4", "ics5", "ics6", "ics7","ics8",
                  "mk1", "mk2", "mk3", "mk4", "mk5",
                  "pbli1", "pbli2", "pbli3", "pbli4", "pbli5", "pbli6", "pbli7", "pbli8",
                  "pcp1", "pcp2", "pcp3", "pcp4", "pcp5", "pcp6",
                  "pppd1", "pppd2", "pppd3", "pppd4", "pppd5", "pppd6", "pppd7", "pppd8", "pppd9", "pppd10", "pppd11",
                  "sbpic1", "sbpic2", "sbpic3", "sbpic4", "sbpic5"]

  def self.format_date(in_date)
    temp_date = in_date.split("/")
    return temp_date[2] + "/" + temp_date[0] + "/" + temp_date[1]
  end

  def self.update_preceptor_eval(row)
     user = User.find_by(email: row["email"])
     if user.nil?
       return false
     else
       row["user_id"] = user.id
       row["submit_date"] = format_date(row["submit_date"])
       #puts row.to_hash
       row_hash = {}
       row_hash = row.to_hash
       row_hash.delete("email")
       row_hash.delete("full_name")
       PreceptorAssess.where(response_id: row["response_id"]).first_or_create.update(row_hash)
     end

     return true
  end

  def self.process_upload_data (artifact, code)
    log_results = []
    row_to_hash = {}
    no_updated = 0
    no_not_updated = 0
    total_count = 0

    CSV.parse(ActiveStorage::Attachment.find(artifact.documents.first.id).download, headers: true, col_sep: "\t", encoding: 'cp1252') do |row|

      #yes_updated = true
      total_count += 1

        yes_updated = false
        if code == 'PreceptorEval' and !row["email"].blank?
          yes_updated = update_preceptor_eval(row)
        elsif code == 'FormativeFeedback' and !row["q1"].blank?
          yes_updated = update_formative_feedback(row)
        end

        if yes_updated
          no_updated += 1
        else
          if code == 'PreceptorEval'
            row_to_hash.store(row["full_name"], " --> NOT Updated")
          elsif code == 'FormativeFeedback'
            row_to_hash.store(row["q1"], " --> NOT Updated")
          end
          no_not_updated += 1
          log_results.push row_to_hash
        end


    end
    # attachment = ActiveStorage::Attachment.find(artifact.documents.first.id)
    # filename = attachment.blob.filename.to_s
    # if !filename.include? 'processed'
    #   attachment.blob.update!(filename: rename_file(filename))
    # end
    row_to_hash = {}
    row_to_hash.store("no_updated", no_updated)
    row_to_hash.store("no_not_updated", no_not_updated)
    row_to_hash.store("total_count", total_count)
    log_results.push row_to_hash

    return log_results

  end

  def self.update_formative_feedback(row)
    if row["sid"].nil?
      email = row["q1"].split(" - ").last
      user = User.find_by(email: email)
    else
      user = User.find_by(sid: row["sid"])
    end
    if user.nil?
      return false
    else
      row["user_id"] = user.id
      row["submit_date"] = format_date(row["submit_date"])
      row["response_id"] = row["response_id"] + row["question_set2"]
      row["q3"] = row["q3"].to_s.gsub("'-", "-")
      row["q4"] = row["q4"].to_s.gsub("'-", "-")
      row["q5"] = row["q5"].to_s.gsub("'-", "-")
      row["q6"] = row["q6"].to_s.gsub("'-", "-")
      #puts row.to_hash
      row_hash = {}
      row_hash = row.to_hash
      row_hash.delete("question_set2")
      row_hash.delete("sid")
      FormativeFeedback.where(response_id: row["response_id"]).first_or_create.update(row_hash)

    end
    return true
  end

  def self.process_formative_feedback_data (artifact)
    log_results = []
    row_to_hash = {}
    no_updated = 0
    no_not_updated = 0
    total_count = 0

    CSV.parse(ActiveStorage::Attachment.find(artifact.documents.first.id).download, headers: true, col_sep: "\t", encoding: 'cp1252') do |row|

      yes_updated = true
      total_count += 1
      if !row["q1"].blank?  # make sure this column is not blank
        yes_updated = false
        yes_updated = update_formative_feedback(row)

        if yes_updated
          no_updated += 1
        else
          row_to_hash.store(row["full_name"], " --> NOT Updated")
          no_not_updated += 1
          log_results.push row_to_hash
        end

      end
    end
    row_to_hash = {}
    row_to_hash.store("no_updated", no_updated)
    row_to_hash.store("no_not_updated", no_not_updated)
    row_to_hash.store("total_count", total_count)
    log_results.push row_to_hash

    return log_results
  end

	def self.format_date(in_date)
		temp_date = in_date.split("/")
		return temp_date[2] + "/" + temp_date[0] + "/" + temp_date[1]
	end

	def self.check_data(row, field_name)
		if row.first.include? field_name
			return row.second
		else
			@log_data.push("#{field_name} not found (label typo?)- Quit processing the sheet")
			return "No Data!"
		end

	end

	def self.get_competencies(row, competency_codes)
		comp_codes = competency_codes.gsub(" ", "").split(",")
		comp_codes.each do |comp|
		  comp = comp.downcase
			row["#{comp}"] = 3
		end
		return row
	end

  def self.check_comp_codes(row)
    comp_codes = row.second.gsub(" ", "").split(",")  # second col contains comp code
    valid_codes = []
    comp_codes.each do |code|
      temp_code = COMP_CODES.select{|c| c if c == code.downcase }
      if temp_code.empty?
        valid_codes.push "Invalid Competency Code = #{code}"
        @log_data.push ("** Invalid Competency Code = #{code}")
      else
        valid_codes.push code
      end
    end
    return valid_codes
  end

	def self.process_tab_sheet(sheet)
		last_row = sheet.count-1
    # sheet.each do |row|
    #   puts row.inspect  # => ["header1", "header2"]
    # end
		course_name = check_data(sheet[0], "Course Name")
		course_id = check_data(sheet[1], "Course ID")
		course_dates = check_data(sheet[2], "Course Dates")
		temp_dates = course_dates.gsub(" ", "").split("-")
		start_date = format_date(temp_dates.first)
	  end_date = format_date(temp_dates.last)
		evaluator = check_data(sheet[3], "Instructor")
		competency_codes = check_data(sheet[4], "Competencies")

    valid_codes = check_comp_codes(sheet[4])
    if !valid_codes.select{|c| c if c.include? "Invalid"}.empty?
      @log_data.push (valid_codes.inspect)
      @log_data.push ("-----------------------------------------------------------------------------------------")
      return
    end
		row = {}

		for r in 6..last_row do
			row["course_name"] = course_name
			row["course_id"] = course_id
			row["start_date"] = start_date
			row["end_date"] = end_date
			row["submit_date"] = Time.now.strftime("%Y/%m/%d")
			row["evaluator"] = evaluator
			row["student_uid"] = sheet[r].first
			row["full_name"] = sheet[r].second
			row["final_grade"] = "{\"Grade\":\"Pass\"}"
			# if row["final_grade"] == 'P'
			# 	row["final_grade"] = "{\"Grade\":\"Pass\"}"
			# else
			# 	row["final_grade"] = "{\"Grade\":\"Fail\"}"
			# end
			row["mspe"] = "N/A"
			row["feedback"] = "N/A"
			#puts "processing " + row["full_name"]

      updated_row = get_competencies(row, competency_codes)
      if updated_row.keys.include? "no data!"
				@log_data.push ("Bad record - please investigate the FIRST 5 row labels --> " + updated_row["full_name"])
				@log_data.push (updated_row.inspect)
				@log_data.push ("-----------------------------------------------------------------------------------------")
        break
        return
			else
				found_error = insert_comp(updated_row)
        if found_error
          break
          return
        end
			end
		end
	end

	def self.insert_comp (row)
			begin
				User.table_name = "users"
				Competency.table_name = "competencies"
				uu = User.find_by(sid: row["student_uid"])
				if !uu.nil?
					row["user_id"] = uu.id
					row["email"] = uu.email
					row["permission_group_id"] = uu.permission_group_id
					row_hash = {}
					row_hash = row.to_hash
          full_name = row_hash["full_name"]
					row_hash.delete("full_name")
					Competency.where(user_id: row["user_id"], email: row["email"], course_id: row["course_id"]).first_or_create.update(row_hash)
          @log_data.push(row["course_name"] + " --> " + full_name.to_s + " is created in Competency table.")

          return false
				 else
					@log_data.push(" *** full_name: " + row["full_name"].to_s + " is not found in users table.")
          return false
				end
			rescue ActiveModel::UnknownAttributeError
				@log_data.push( "Try to process " + uu.full_name + " and ourse_name: " + row_hash["course_name"])
			  @log_data.push( "Sorry your transaction failed. Reason: UnknownAttributeError - check competency codes.. ")
				@log_data.push( 'FieldNames: ')
				@log_data.push( row_hash.keys.inspect)
        return
			end

	end

  def self.read_competency_excel(artifact)
    @log_data = []
    xlsx = Xsv::Workbook.open(ActiveStorage::Attachment.find(artifact.documents.first.id).blob.download)
    # xlsx = Xsv.open(file)
    xlsx.sheets.each do |sheet|
    	if sheet.name != 'Upload'
    		@log_data.push ("Sheet Name: " + sheet.name)
    		@log_data.push ("No of rows: " + sheet.count.to_s)
    		process_tab_sheet(sheet)
    		@log_data.push ("===================================")
    	end
    end
    xlsx.close
    todayDate = Time.now.strftime("%Y_%m_%d")
    filename = "#{Rails.root}/log/competency_#{todayDate}.log"
    File.open(filename, 'w') {
      |f| @log_data.each { |line| f << "\r\n" + line }
    }
  end

  def self.insert_blses (row)
      begin
        UmeBls.table_name = "ume_blses"
        uu = User.find_by(sid: row["sid"])
        if !uu.nil?
          row["user_id"] = uu.id
          row_hash = {}
          row_hash = row.to_hash
          full_name = uu.full_name
          row_hash.delete("first_name")
          row_hash.delete("last_name")
          row_hash.delete("sid")

          s = UmeBls.where(user_id: uu.id).first_or_create.update(row_hash)
          # puts "s --> " + s.inspect
          # puts "user id: " + uu.id.to_s
          @log_data.push(row["user_id"].to_s + " --> " + full_name.to_s + " is created in UmeBlses table.")
          return false
         else
          @log_data.push(" *** full_name: " + row["last_name"].to_s + ", " + row["first_name"].to_s + " is not found in users table.")
          return false
        end
    end
  end

  def self.read_bls_excel(artifact)
    @log_data = []
    xlsx = Xsv::Workbook.open(ActiveStorage::Attachment.find(artifact.documents.first.id).blob.download)
    # xlsx = Xsv.open(file)
    xlsx.sheets.each do |sheet|
    	if sheet.name != 'Upload'
    		@log_data.push ("Sheet Name: " + sheet.name)
    		@log_data.push ("No of rows: " + sheet.count.to_s)
        last_row = sheet.count-1
    		row = {}
        
    		for r in 1..last_row do
          #puts sheet[r].inspect
    			row["last_name"] = sheet[r][0]
    			row["first_name"] = sheet[r][1]
          row["sid"] = sheet[r][2]
          if sheet[r][3].to_s == ""
            row["expiration_date"] = nil
          else
    		  	row["expiration_date"] = sheet[r][3].to_time.strftime("%Y/%m/%d")
          end
    			row["comments"] = sheet[r][4]
    			found_error = insert_blses(row)
          if found_error
            break
            return
          end
    		end

    		@log_data.push ("===================================")
    	end
    end
    xlsx.close
    todayDate = Time.now.strftime("%Y_%m_%d")
    filename = "#{Rails.root}/log/bls_#{todayDate}.log"
    File.open(filename, 'w') {
      |f| @log_data.each { |line| f << "\r\n" + line }
    }

  end

end
