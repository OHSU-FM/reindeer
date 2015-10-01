module LimeExt
    
    ##
    # Class: LimeData
    #
    # The LimeData class is used to generate datasets from LimeSurvey datasets
    class LimeData < LimeExt::PolyTableModel
        attr_accessor :questions, :user
        
        ##
        # Class methods
        
        ##
        # Instance Methods
        
        ##
        #
        def initialize lime_survey
            @lime_survey = lime_survey
            @sid = lime_survey.sid
        end
        
        ##
        # return dataset/return copy if already generated
        def dataset
            if !defined?(@dataset) || @dataset.nil? || dataset_stale?
                @dataset = Rails.cache.fetch(cache_store_key, :expires_in=>3.minutes) do
                    self.class.run_sql(query)
                end
                @lime_survey.wipe_response_sets
                @dataset_stale = false
            end
            return @dataset
        end
        
        def cache_store_key
            [   self.class.name,
                query,
                @lime_survey,
                @lime_survey.role_aggregate
            ]
        end
         
        ##
        # Return name of table for this survey
        def self.table_name sid
            return "#{LimeExt.table_prefix}_survey_#{sid}"
        end
        
        def column_to_question col
            lime_survey.lime_questions.find{||} 
        end       
    end
end

