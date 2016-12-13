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
            result.push rs.title
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
                break
            end
        end
        return false
    end 
end
