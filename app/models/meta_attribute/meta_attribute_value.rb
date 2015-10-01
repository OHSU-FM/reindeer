module MetaAttribute
    class MetaAttributeValue < ActiveRecord::Base
        belongs_to :meta_attribute_statistic
    end
end
