class SearchesController < ApplicationController
  before_action :authenticate_user!, :set_resources
  include SearchesHelper
  layout 'full_width_csl'

  def search_by_email
    if params[:email].present?
      @results = User.where(email: params[:email]).select(:id, :full_name, :username, :email, :sid, :uuid, :coaching_type,
                :permission_group_id, :prev_permission_group_id, :spec_program, :matriculated_date, :new_competency, :is_ldap, :former_name, :career_interest)
    end
  end

  def search
    if current_user.coaching_type == "student" and params[:search].nil?
      @results = []
      @results.push current_user
    elsif params[:search] == '?' or params[:search].to_s == 'help'
      @results = @help
    elsif params[:search].blank?
      redirect_to(root_path, alert: "Empty field! - Please Enter Something!") and return
    elsif params[:search].include? "@"
      @results = User.where(email: params[:search]).select(:id, :full_name, :username, :email, :sid, :uuid, :coaching_type,
                :permission_group_id, :prev_permission_group_id, :spec_program, :matriculated_date, :new_competency, :is_ldap, :former_name).order(:full_name)
    elsif params[:search] == 'PhD' or params[:search] == 'MPH' or params[:search] == 'MCR' #current_user.spec_program == "PhD"
      @results = User.where(permission_group_id: 7 ).select(:id, :full_name, :username, :email, :sid, :coaching_type,
                :permission_group_id, :prev_permission_group_id, :spec_program, :matriculated_date, :uuid, :new_competency, :is_ldap, :former_name).order(:full_name)
      params[:search] = 'PhD'  ##use this test in index page or file
      @file_name = hf_create_download_file(@results, params[:search])
    elsif params[:search] == "Wy'east"  #current_user.spec_program == "Wy'east"
      @parameter = params[:search] + "%"
      @results = User.where("coaching_type='student' and spec_program like 'MD/Wy%'")
    elsif params[:search].include? "Med"
      @parameter = "%" + params[:search] + "%"
      permission_group = PermissionGroup.where("title like ?", @parameter)
      if !permission_group.empty?
        #joins_query = "inner join permission_groups on users.permission_group_id = permission_groups.id and permission_groups.title like " + "#{@parameter}" + " order by users.full_name"
        @results = User.where(permission_group_id: permission_group.first.id ).select(:id, :full_name, :username, :email, :sid, :coaching_type,
                  :permission_group_id, :prev_permission_group_id, :spec_program, :matriculated_date, :new_competency, :is_ldap, :former_name).order(:full_name)

        @file_name = hf_create_download_file(@results, params[:search])
      else
        @result = nil
      end
    #     coach_search
    elsif !params[:search].downcase.include? "med18"

      if params[:search].strip.first(2). == 'U0'
        @parameter = params[:search].strip + "%"
        @results = User.where("sid LIKE :search and coaching_type='student' and sid is not null", search: @parameter).select(:id, :full_name, :username, :email, :sid, :uuid, :coaching_type,
                  :permission_group_id, :prev_permission_group_id, :spec_program, :matriculated_date,:new_competency, :former_name).order(:full_name)
      else
          @parameter = params[:search].strip.downcase + "%"
          @results = User.where("lower(full_name) LIKE :search and coaching_type='student' ", search: @parameter).select(:id, :full_name, :username, :email, :sid, :uuid, :coaching_type,
                    :permission_group_id, :prev_permission_group_id, :spec_program, :matriculated_date, :new_competency, :former_name, :career_interest).order(:full_name)
                if @results.blank?
                @results = "<h5>Record NOT found for #{params[:search]}!!</h5>"
              end
      end
    else
      redirect_to(root_path, alert: "No records found for #{params[:search]}")
      # @student_year = hf_student_year(params[:search])
      # @class_comp = Competency.order('student_name').where(student_year: @student_year).page(params[:page])
      # if @class_comp.empty?
      #   redirect_to(root_path, alert: "No records found for #{params[:search]}")
      # else
      #   @class_mean_exist = true
      #   @clinical_sid = hf_dataset_sid(params[:search])
      # end
    end
    if @results.blank?
      redirect_to(root_path, alert: "No records found for #{params[:search]}")
    end

    # respond_to do |format|
    #   #format.js { render partial: 'search-results'}
    #   format.html
    # end
  end

  def download_file
      if params[:file_name].present?
        private_download params[:file_name]
      end
  end

  private

   def set_resources
     #@crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base[0..31], Rails.application.secrets.secret_key_base)
     if session[:aes_key].nil?
       aes_key = AES.key
       session[:aes_key] = aes_key
     end

     if File.exist? (Rails.root + "config/search_help.txt")
       file ||= File.read(Rails.root + "config/search_help.txt")
       file = file.gsub("\r\n", "")
       @help = file.html_safe
     else
       @help = "<h4>Missing Help File!</h4".html_safe
     end

   end

   def private_download in_file
      send_file  "#{Rails.root}/tmp/#{in_file}", type: 'text', disposition: 'download'
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
