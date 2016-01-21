module MetaAttribute
    class MetaAttributeQuestion < ActiveRecord::Base
        attr_accessible :meta_attribute_entity_entity_type,
            :attribute_name,
            :short_name,
            :category,
            :description,
            :data_type,
            :continuous,
            :optional,
            :visible,
            :original_text,
            :options_hash

        belongs_to :meta_attribute_entity,
            :foreign_key=>:meta_attribute_entity_entity_type, #my column
            :primary_key=>:entity_type # Their column

        has_one :meta_attribute_entity_group, :through=>:meta_attribute_entity
        serialize :options_hash, Hash

        rails_admin do
            field :meta_attribute_entity do
                inline_edit false
                inline_add false
            end
            include_all_fields
        end

        def name
            description
        end

        def data_type_enum
            @data_type_enum = self.class.pluck(:data_type).uniq
        end

    end
end
