module LsReports::SpreadsheetHelper
    def hf_get_response_sets lime_survey, filters=[]
        result = []
        lime_survey.lime_questions.select do |lq|
            if (filters.empty? || filters.include?(lq.qid)) && lq.response_set.data.present?
                if lq.response_set.data.first.respond_to? :data
                    result += lq.response_set.data
                else
                    result.push lq.response_set
                end
            end
        end
        return result
    end

    def hf_flatten_response_sets lime_survey
        result = []
        lime_survey.lime_groups.each do |vgroup|
            vgroup.parent_questions.each do |pquestion|
                if pquestion.response_set.data.first.respond_to? :data
                    # data is an array of sub question data
                    result += pquestion.response_set.data
                  
                else
                    result.push pquestion.response_set
                end
            end
        end
        return result
    end

    def hf_transpose_response_sets response_sets

        result = []
        temp_data = []
        response_sets.each do |dt|
            temp_data.push dt.data
        end
        temp_data = temp_data.transpose

        temp_hash = {}
        title_array = hf_transpose_titles response_sets
        temp_data.each do |x|
            temp_hash = Hash[title_array.zip(x)]
            result.push temp_hash
        end
        return result

    end

    def hf_transpose_titles response_sets
        result = []
        response_sets.each do |rs|
        case rs.title
            when "PPPD01"
              result.push "PPPD1"
            when "PPPD02"
              result.push "PPPD2"
            when "PPPD03"
              result.push "PPPD3"
            when "PPPD04"
              result.push "PPPD4"
            when "PPPD05"
              result.push "PPPD5"
            when "PPPD06"
              result.push "PPPD6"
            when "PPPD07"
              result.push "PPPD7"
            when "PPPD08"
              result.push "PPPD8"
            when "PPPD09"
              result.push "PPPD9"
            else
              result.push rs.title
            end


        end
        return result
    end

    def hf_transpose_questions response_sets
        result = {}
        response_sets.each do |rs|
            pquestion = rs.question
            result[rs.title] =  pquestion.question
        end

        return result

    end

    def hf_found_competency response_sets

        response_sets.each do |rs|
            if rs.title.include? "ICS1"
                return true
            end
        end
        return false
    end

   def hf_parse_grade json_str
     begin
       arry = JSON.parse(json_str)
       return arry["Grade"]
     rescue
       return json_str
     end
   end

   def hf_check_display_json json_str
     begin
       arry = JSON.parse(json_str)
       long_str = ""
       long_str += "<table>"
       arry.each do |key, value|
         long_str += "<tr><td>#{key}</td><td>#{value}</td><tr>"
       end
       long_str += "</table>"
       return long_str
     rescue
       return json_str
     end
   end
end
