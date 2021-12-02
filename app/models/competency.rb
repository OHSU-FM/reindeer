class Competency < ApplicationRecord
  belongs_to :user

  def self.write_hash_to_json_file(hash, filename)
     File.open(filename,"w") do |f|
       f.write(JSON.pretty_generate(hash))
     end
  end

  def self.load_class_mean(permission_group_id)
    today_date = Date.today.to_s
    file_name = "#{Rails.root}/tmp/class_mean_#{permission_group_id}_#{today_date}.json"
    if File::exists?(file_name)
      file = File.read(file_name)
      return JSON.parse(file)
    else
      return nil
    end

  end

  def self.create_class_mean(class_mean, permission_group_id)
      today_date = Date.today.to_s
      write_hash_to_json_file(class_mean, "#{Rails.root}/tmp/class_mean_#{permission_group_id}_#{today_date}.json" )
  end

  def self.execute_sql(*sql_array)
    connection.exec_query(send(:sanitize_sql_array, sql_array))
  end

  def self.rearrange_data(all_blocks)
    temp_hash = {}
    keys = ['Comp1', 'Comp2', 'Comp3', 'Comp4', 'Comp5']

    keys.each do |comp_key|
      selected = []
      all_blocks.each do |block|
          selected.push block.map{|key, val| val if key.include? comp_key.downcase }.compact  # remove all nil data
      end
      selected = selected.flatten.map(&:to_f)  ## flatten the array and convert the data to float
      temp_hash.store(comp_key, selected)
    end

    return temp_hash
  end

  def self.all_blocks_mean(selected_user)
    all_blocks_class_mean_sql = 'select course_code,
            trunc(avg(summary_comp1),2) as "ave_summ_comp1",
            trunc(avg(summary_comp2a),2) as "ave_summ_comp2a",
            trunc(avg(summary_comp2b),2) as "ave_summ_comp2b",
            trunc(avg(summary_comp3),2) as "ave_summ_comp3",
            trunc(avg(summary_comp4),2) as "ave_summ_comp4",
            trunc(avg(summary_comp5a),2) as "ave_summ_comp5a",
            trunc(avg(summary_comp5b),2) as "ave_summ_comp5b"
          FROM fom_exams  where permission_group_id=' + "#{selected_user.permission_group_id}" +
          'group by course_code
          order by course_code'

      all_blocks_user_sql = 'select course_code,
              trunc(summary_comp1,2) as "summ_comp1",
              trunc(summary_comp2a,2) as "summ_comp2a",
              trunc(summary_comp2b,2) as "summ_comp2b",
              trunc(summary_comp3,2) as "summ_comp3",
              trunc(summary_comp4,2) as "summ_comp4",
              trunc(summary_comp5a,2) as "summ_comp5a",
              trunc(summary_comp5b,2) as "summ_comp5b"
            FROM fom_exams  where permission_group_id=' + "#{selected_user.permission_group_id}" +
            ' and user_id=' + "#{selected_user.id}" +
            'order by course_code'

      all_blocks_class_mean_results = Competency.execute_sql(all_blocks_class_mean_sql)
      all_blocks_results = Competency.execute_sql(all_blocks_user_sql)

      category_labels = all_blocks_results.rows.transpose.first  ## grab the block name
      all_blocks_class_mean = rearrange_data(all_blocks_class_mean_results.to_a)
      all_blocks = rearrange_data(all_blocks_results.to_a)

      return all_blocks, all_blocks_class_mean, category_labels

  end

end
