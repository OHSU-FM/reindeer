module MetaAttribute
    class MetaAttributeStatistic < ActiveRecord::Base
        has_many :meta_attribute_values
        has_one :meta_attribute_question,
            :class_name=>'MetaAttribute::MetaAttributeQuestion',
            :foreign_key=>[:meta_attribute_entity_entity_type, :attribute_name],
            :primary_key=> [:entity_name, :attribute_name]
        def category
            meta_attribute_question.to_s == '' ? 'Uncategorized' : meta_attribute_question.category
        end
    end
end
