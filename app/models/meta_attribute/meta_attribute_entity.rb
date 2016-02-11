module MetaAttribute
    class MetaAttributeEntity < ActiveRecord::Base
        attr_accessible :meta_attribute_entity_group_group_name,
            :entity_type,
            :entity_type_fk,
            :edition,
            :reference_year,
            :start_date,
            :stop_date,
            :visible

        belongs_to :meta_attribute_entity_group,
            :foreign_key=>:meta_attribute_entity_group_group_name, # my field name
            :primary_key=>:group_name, # Their field name
            :inverse_of=>:meta_attribute_entities

        has_many :meta_attribute_questions,
            :foreign_key=>:meta_attribute_entity_entity_type, # Their field
            :primary_key=>:entity_type #my field being matched against

        validate :validate_table_and_pk

        rails_admin do
            field :id
            field :reference_year, :enum
            field :entity_type, :enum
            field :entity_type_fk, :enum
            include_all_fields
        end

        # Require that table exists and that column exists in table
        def validate_table_and_pk
            if entity_type.nil?
                entity_type_pk=nil
                return
            end

            if entity_type_pk.nil?
                entity_type=nil
                return
            end

            unless entity_type_enum.include? entity_type.to_s
                errors.add :entity_type, :invalid
                return
            end
            unless entity_type_pk_enum.include? entity_type_pk.to_s
                errors.add :entity_type_pk, :invalid
                return
            end
        end

        def name
            entity_type
        end

        def group_name
            meta_attribute_entity_group_group_name
        end

        def model
            @model ||= self.entity_type.singularize.classify.constantize
        end

        def belongs_to_keys
            model.reflect_on_all_associations(:belongs_to).map{|reflection|reflection.foreign_key}
        end

        def reference_year_enum
            %w'2006 2007 2008 2009 2010 2011 2012'
        end

        # Translate this record
        def translate row, cols = nil
            # Get table name
            name = row.class.table_name

            # translate row
            result = {}

            # Use all columns if none were specified
            cols = row.class.columns.map{|col|col.name} if cols.nil?

            # Look for translations
            cols.each do |col|
                # Current val
                val = row[col]
                # Does this question exist in the dictionary
                q = self.meta_attribute_questions.find{|q| q.name==col}
                next if q.data_type == "character varying"

                if q.nil? || q.meta_attribute_answers.nil?
                    # Not found in dictionary
                    result[col] = val
                    next
                end

                # Does this value exist in the dictionary?
                new_val = q.meta_attribute_answers.find{|ans| ans.value == val.to_s }
                result[col] = new_val.nil? ? val : new_val.description
            end

            return result
        end

        def self.entity_groups_enum
            # Provide a dictionary summarizing information about entity groups
            groups = {}
            self.all.each do |mae|
                parm = mae.group.parameterize
                groups[parm] = {:years=>Set.new,:name=>mae.group} if groups[parm].nil?
                groups[parm][:years].add(mae.start_date.year)
            end
            return groups
        end

        def entity_type_enum
            return ActiveRecord::Base.connection.tables.sort
        end

        def entity_type_fk_enum
            return [] unless entity_type
            ActiveRecord::Base.connection.columns(entity_type).map{|col|col.name}
        end

    end
end
