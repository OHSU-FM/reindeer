module LimeExt
    
    ##
    # Class: LimeData
    #
    # The LimeData class is used to generate datasets from LimeSurvey datasets
    class LimeTokens < LimeExt::PolyTableModel
        ##
        #
        def initialize lime_survey
            @lime_survey = lime_survey
            @sid = lime_survey.sid
        end
        
        ##
        # Return name of table for this survey
        def self.table_name sid
            return "#{LimeExt.table_prefix}_tokens_#{sid}"
        end

    end
end
