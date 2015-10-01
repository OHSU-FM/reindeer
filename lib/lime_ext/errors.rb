module LimeExt
    module Errors
        class LimeDataFiltersError < StandardError; end
        class LimeQueryError < StandardError; end
        class LimeMissingTable < StandardError; end
    end
end

