class CreateChartBuilder < ActiveRecord::Migration
  def up
    
    # 
    create_table :charts do |t|
        t.references :user, :index=>true    # User_id
        t.text :title                       # Title of a chart
        t.text :output                      # Cached dataset 
        t.text :chart_type                  # Display type
        t.text :aggregator_type             # Custom Aggregator (optional)
        t.text :cols                        #
        t.text :rows                        #
        t.text :years_filter                #
        t.timestamps                        # 
    end

    create_table :chart_series do |t|       
        t.references :chart, :index=>true       # Belongs to chart
        t.text :group_filter                    #
        t.text :entities_filter                 #
        t.text :category_filter                 #
        t.text :question_filter                 #
        t.text :question_options_filter         #
        t.timestamps                            #
    end

  end

  def down
    drop_table :charts
    drop_table :chart_series
  end
end
