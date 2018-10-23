class ExtendMetaAttributes < ActiveRecord::Migration[4.2]
  def change

    create_table :meta_attribute_entities do |t|
      t.text :entity_type                                       #
      t.text :entity_group, :index=>true                        #
      t.integer :edition                                        # 
      t.integer :version                                        #
      t.integer :reference_year                                 #
      t.date :start_date                                        #
      t.date :stop_date                                         #
      t.boolean :visible, :default=>true                        #
    end
     
    create_table :meta_attribute_questions do |t|
        t.references :meta_attribute_entity
        t.text :category, :index=>true                          # Category
        t.text :attribute_name, :index=>true                    # Column name
        t.text :description                                     # Description of question
        t.text :original_text                                   # Text as stated on survey
        t.text :data_type                                       # Data type
        t.text :options_hash                                    # Options for question   
        t.boolean :continuous                                   # Is the variable continuous?
        t.boolean :optional                                     # Is the question optional?
        t.boolean :visible, :default=>true                      # visible to public?
    end

  end
end


