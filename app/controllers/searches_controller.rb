class SearchesController < ApplicationController
  before_action :authenticate_user!, :set_resources
  include SearchesHelper
  layout 'full_width_csl'

  def search
    if current_user.coaching_type == "student"
      @results = []
      @results.push current_user
    elsif params[:search].blank?
      redirect_to(root_path, alert: "Empty field! - Please Enter Something!") and return
    elsif current_user.spec_program == "PhD"
      #@results = User.where(coaching_type: 'student', spec_program: 'PhD')
      @parameter = params[:search].downcase + "%"
      @results = User.where("lower(full_name) LIKE :search and coaching_type='student' and spec_program like 'MD/PhD%'", search: @parameter)
      if @results.blank?
        redirect_to(root_path, alert: "No records found for #{params[:search]}")
      end
    elsif current_user.spec_program == "MPH"
      #@results = User.where(coaching_type: 'student', spec_program: 'PhD')
      @parameter = params[:search].downcase + "%"
      @results = User.where("lower(full_name) LIKE :search and coaching_type='student' and spec_program like 'MD/MPH%'", search: @parameter)
      if @results.blank?
        redirect_to(root_path, alert: "No records found for #{params[:search]}")
      end

    elsif current_user.spec_program == "Wy'east"
      @parameter = params[:search].downcase + "%"
      @results = User.where("lower(full_name) LIKE :search and coaching_type='student' and spec_program like 'MD/Wy%'", search: @parameter)
      if @results.blank?
        redirect_to(root_path, alert: "No records found for #{params[:search]}")
      end

    elsif current_user.coaching_type == 'coach'
        coach_search
    elsif !params[:search].downcase.include? "med18"

      if params[:search].first(2) == 'U0'
        @parameter = params[:search] + "%"
        @results = User.where("sid LIKE :search and coaching_type='student' and sid is not null", search: @parameter).select(:id, :full_name, :username, :email, :sid, :uuid, :coaching_type,
                  :permission_group_id, :prev_permission_group_id, :spec_program, :matriculated_date).order(:full_name)

      else
        # if params[:search] == 'Le'
        #   @parameter = params[:search] + "%"
        #   @results = User.where("full_name LIKE ? and coaching_type='student'", "Le%").select(:id, :full_name, :username, :email, :sid, :uuid, :coaching_type,
        #             :permission_group_id, :prev_permission_group_id, :spec_program, :matriculated_date).order(:full_name)
        #
        # else
          @parameter = params[:search].downcase + "%"
          @results = User.where("lower(full_name) LIKE :search and coaching_type='student' ", search: @parameter).select(:id, :full_name, :username, :email, :sid, :uuid, :coaching_type,
                    :permission_group_id, :prev_permission_group_id, :spec_program, :matriculated_date).order(:full_name)
        # end
      end
    else
      @student_year = hf_student_year(params[:search])
      @class_comp = Competency.order('student_name').where(student_year: @student_year).page(params[:page])
      if @class_comp.empty?
        redirect_to(root_path, alert: "No records found for #{params[:search]}")
      else
        @class_mean_exist = true
        @clinical_sid = hf_dataset_sid(params[:search])
      end
    end
    render :search
    # respond_to do |format|
    #   #format.js { render partial: 'search-results'}
    #   format.html
    # end
  end

  private

   def set_resources
     #@crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31], Rails.application.secrets.secret_key_base)
     aes_key = AES.key
     session[:aes_key] = aes_key
   end

  def load_all_students cohorts
    cohorts.each do |cohort|
        cohort.users.each do |user|
          @results.push user
        end
      end
  end

  def coach_search
    @results = []
    @parameter = params[:search].downcase
    cohorts = current_user.cohorts

    if @parameter == "*"
      load_all_students(cohorts)
    else
        if !['med18', 'med19', 'med20', 'med21', 'med22', 'med23', 'med24', 'med25'].include? @parameter
          cohorts.each do |cohort|
            user = User.find_by("cohort_id = ? and full_name LIKE ?",  "#{cohort.id}", "#{@parameter.capitalize}%")
            @results.push user if !user.nil?
          end
        else
          cohort = cohorts.select{|c| c.title.downcase.include? @parameter}
          cohort.first.users.each do |user|
            @results.push user
          end
      end

      #cohorts.each do |cohort|
        # Looking for med18, med19, etc in the title
        # if !['med18', 'med19', 'med20', 'med21', 'med22', 'med23'].include? @parameter
        #   cohort.users.each do |user|
        #     if user.full_name.downcase.include? @parameter
        #         @results.push user
        #     end
        #   end
        # elsif cohort.title.downcase.include? @parameter
        #   cohort.users.each do |user|
        #     @results.push user
        #   end
        #end
      end
    end

end
