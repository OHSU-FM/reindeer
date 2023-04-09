module ReportsHelper

  BLOCKS = ['1-FUND', '2-BLHD', '3-SBM', '4-CPR', '5-HODI', '6-NSF', '7-DEVH']

  WHERE_QUERY =
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? and ' +
          'course_name not like ? and course_name not like ? '

  def average_summary(summary_data, user)
    student_hash = {}
    student_hash.store('Student', user.full_name)
    student_hash.store('Email', user.email)
    total_score = 0.0
    average = 0.0

    BLOCKS.each do |block|
      found_block = summary_data.select{|s| s['course_code'] if s['course_code'] == block}
      if !found_block.empty?
        student_hash.store(found_block.first['course_code'] + ' Summary', found_block.first['average'].to_f)
        total_score += found_block.first['average'].to_f
      else
        student_hash.store(block + ' Summary', 0.0)
      end
    end

    no_of_blocks = summary_data.count
    average = total_score/7.0 #if no_of_blocks != 0
    student_hash.store('Cumulative FoM Average', average.round(2))
    return student_hash
  end

  def hf_get_ranking(users)
    data_array = []
    data_hash = {}
    users.each do |user|
      if user.username != 'bettybogus'
        summary_data = FomExam.execute_sql('select id, user_id, course_code, summary_comp1, summary_comp2a, summary_comp2b,
                        summary_comp3, summary_comp4, summary_comp5a, summary_comp5b,
                        ROUND((SUMMARY_COMP1+SUMMARY_COMP2A+SUMMARY_COMP2B+SUMMARY_COMP3+SUMMARY_COMP4+SUMMARY_COMP5A+SUMMARY_COMP5B)/7::numeric,2) AS Average
                        from fom_exams where user_id=#{user.id} order by course_code').to_a

          data_hash = average_summary(summary_data, user)
          data_array.push data_hash
      end
    end
    #data_array = data_array.sort_by{ |d| d['Cumulative FoM Average']}.reverse!
    # to sort the average in descending order - done in jquery using dataTables features
    return data_array
  end

  def hf_get_mspe_data_by_email(email, permission_group_id)
    permission_group_title = PermissionGroup.find(permission_group_id.to_i).title.split(' ').last.gsub(/[()]/, '')
    mspe_data = []
    if permission_group_title == "Med23"
      mspe = Med23Mspe.find_by(email: email).user.competencies.where(WHERE_QUERY, '%FoM%', '%JCON%', '%TRAN%', '%PREC 724%', '%SCHI%', '%CPX 702%', '%FAMP 705SD%', '%GMED 705AB%',
      '%IMEDMINF 705B%', '%MULT 705A%', '%MULT 705C%', '%MULT 705D%', '%MULT 705TI%', '%709Z%').select(:id, :student_uid, :user_id, :email,
        :course_id, :course_name, :final_grade, :start_date, :end_date, :submit_date, :evaluator, :prof_concerns, :mspe,
      ).order(:user_id, :start_date)
      mspe_data.push mspe
      return mspe_data
    end
  end

  def hf_get_mspe_data (permission_group_id)
    permission_group_title = PermissionGroup.find(permission_group_id.to_i).title.split(' ').last.gsub(/[()]/, '')
      # query_select = ':student_uid, :user_id, :users.permission_group_id, :competencies.email, ' +
      #   ':course_id, :course_name, :final_grade, :start_date, :end_date, :submit_date, :evaluator, ' +
      #   ':prof_concerns, :comm_prof_concerns, :overall_summ_comm_perf, :add_comm_on_perform, :mspe, :clinic_exp_comment '



      # query_params = "'%FoM%', '%JCON%', '%TRAN%', '%PREC 724%', '%SCHI%', '%CPX 702%', '%FAMP 705SD%', '%GMED 705AB%', " +
      #                "'%IMEDMINF 705B%', '%MULT 705A%', '%MULT 705C%', '%MULT 705D%', '%MULT 705TI%', '%709Z%'"

    mspe_data = []
    if permission_group_title == "Med23"
      Med23Mspe.all.each do |mspe|
         mspe = mspe.user.competencies.where(WHERE_QUERY, '%FoM%', '%JCON%', '%TRAN%', '%PREC 724%', '%SCHI%', '%CPX 702%', '%FAMP 705SD%', '%GMED 705AB%',
         '%IMEDMINF 705B%', '%MULT 705A%', '%MULT 705C%', '%MULT 705D%', '%MULT 705TI%', '%709Z%').select(:id, :student_uid, :user_id, :email,
           :course_id, :course_name, :final_grade, :start_date, :end_date, :submit_date, :evaluator, :prof_concerns, :mspe,
         ).order(:user_id, :start_date)
         mspe_data.push mspe
      end
    end
    return mspe_data

  end

  def hf_cohorts_comp_graph(comp_class_means)
    selected_categories = comp_class_means.first.last.keys
    height = 600
    title =  'Competency By Cohort(s) Graph' #+ '<br ><b>' + '(n = #{tot_count})' + '</b>'

    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(text: title)
      #f.subtitle(text: '<br /><h4>Student: <b>' + student_name + '</h4></b>')
      f.xAxis(categories: selected_categories,
        labels: {
              style:  {
                          fontWeight: 'bold',
                          color: '#000000'
                      }
                }
      )
      comp_class_means.keys.each do |key|
          f.series(type: 'column', name: key, yAxis: 0, data: comp_class_means['#{key}'].values)
      end

      # ['#FA6735', '#3F0E82', '#1DA877', '#EF4E49']
      # f.colors(['#4572A7',
      #           '#AA4643',
      #           '#89A54E',
      #           '#80699B',
      #           '#3D96AE',
      #           '#DB843D',
      #           '#92A8CD',
      #           '#A47D7C',
      #           '#B5CA92'
      #           ])

      f.yAxis [
         { min: 0, max: 100,
           tickInterval: 25,
           title: {text: '<b>Competency (%) </b>', margin: 20}
         }
      ]
      f.plot_options(
        pie: {
            dataLabels: {
                enabled: true,
                crop: false,
                format: '<b>{point.name}</b>:<br>{point.percentage:.1f} %<br>value: {point.y}'
            }
        },
        column: {
            dataLabels: {
                enabled: true,
                crop: false,
                overflow: 'none'
            }
        },
        series: {
          cursor: 'pointer'
        }
      )
      f.legend(align: 'center', verticalAlign: 'bottom', y: 0, x: 0)
      #f.legend(align: 'right', verticalAlign: 'top', y: 75, x: -50, layout: 'vertical')
      f.chart({
                defaultSeriesType: 'column',
                width: 1800, height: height,
                plotBackgroundImage: ''
              })
    end

    return chart

  end


end
