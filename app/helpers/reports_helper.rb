module ReportsHelper

  BLOCKS = ["1-FUND", "2-BLHD", "3-SBM", "4-CPR", "5-HODI", "6-NSF", "7-DEVH"]

  def average_summary(summary_data, user)
    student_hash = {}
    student_hash.store("Student", user.full_name)
    student_hash.store("Email", user.email)
    total_score = 0.0
    average = 0.0

    BLOCKS.each do |block|

      found_block = summary_data.select{|s| s["course_code"] if s["course_code"] == block}
      if !found_block.empty?
        student_hash.store(found_block.first["course_code"], found_block.first["average"].to_f)
        total_score += found_block.first["average"].to_f
      else
        student_hash.store(block, 0.0)
      end
      # summary_data.each do |data|
      #   if !data["average"].nil?  #data["course_code"] == block and
      #       student_hash.store(data["course_code"], data["average"])
      #       total_score += data["average"]
      #   else
      #      student_hash.store(block, 0.0)
      #   end
      # end
    end
    no_of_blocks = summary_data.count
    average = total_score/7.0 #if no_of_blocks != 0
    student_hash.store("Cumulative FoM Average", average.round(2))
    return student_hash
  end

  def hf_get_ranking(users)
    data_array = []
    data_hash = {}
    users.each do |user|
      if user.username != 'bettybogus'
          summary_data = FomExam.execute_sql("select id, user_id, course_code, summary_comp1, summary_comp2a, summary_comp2b,
                          summary_comp3, summary_comp4, summary_comp5a, summary_comp5b,
                          ROUND((SUMMARY_COMP1+SUMMARY_COMP2A+SUMMARY_COMP2B+SUMMARY_COMP3+SUMMARY_COMP4+SUMMARY_COMP5A+SUMMARY_COMP5B)/7::numeric,2) AS Average
                          from fom_exams where user_id=#{user.id} order by course_code").to_a

          # if summary_data.count == 7
            data_hash = average_summary(summary_data, user)
            data_array.push data_hash
          # end
      end
    end

    return data_array
  end
end
