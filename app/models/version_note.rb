class VersionNote < ActiveRecord::Base
    has_many :versions
    has_many :possible_versions, ->{
            where "version_note_id IS NULL OR version_note_id = '#{self.id}'"
        },
        :class_name=>"Version"
    validates_presence_of :note
    validates_presence_of :versions
    attr_accessible :id, :note, :version_ids, :possible_version_ids

    rails_admin do
        field :versions do

        end

        edit do
            field :versions, :has_many_association do
                associated_collection_cache_all false
                associated_collection_scope do
                    note = bindings[:object]
                    Proc.new {|scope|
                        if note.nil? || note.id.nil?
                            scope = scope.where("version_note_id IS NULL")
                        else
                            scope = scope.where("version_note_id IS NULL OR version_note_id = #{note.id}")
                        end
                    }
                end

            end
            field :note
        end
        field :note
        navigation_label 'Dataset Changes'
        label_plural "Notes"
    end


end
