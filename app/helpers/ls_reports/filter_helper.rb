module LsReports::FilterHelper
    DROPDOWN_TYPES = %w{1 5 A B C E F G H K L M O P R Y ! ; :}
    def hf_pquestion_gets_dropdown? pquestion
        DROPDOWN_TYPES.include?(pquestion.type)
    end
end
