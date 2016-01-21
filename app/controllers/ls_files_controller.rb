class LsFilesController < ApplicationController

    include LsReportsHelper

    def show

        # Pull lime_survey dataset
        fm = LsReportsHelper::FilterManager.new current_user, params[:sid]
        authorize! :read_raw_data, fm.lime_survey

        # add filter for user
        fm.lime_survey.add_filter :id, params[:row_id]

        # Find File Question
        question = fm.lime_survey.find_question :qid, params[:qid].to_i
        # Redirect if we can't find that question
        unless question
            #simple_redirect
            raise ActiveRecord::RecordNotFound.new('Question not found')
            return
        end

        # redirect if we can't find file information
        files_info = question.response_set.data.first
        f_inf = files_info[:files].find{|f_inf|f_inf['name'] == params[:name]}
        unless f_inf
            #simple_redirect
            raise ActionController::RoutingError.new('File not Found')
            return
        end

        # Redirect if we can't find the file on disk
        fpath = "#{Settings.lime_uploads_dir}/surveys/#{fm.lime_survey.sid}/files/#{f_inf['filename']}"
        unless File.exists? fpath
            #simple_redirect
            raise ActionController::RoutingError.new('File not Found')
            return
        end

        # Send the file
        send_file fpath, :filename=>f_inf['name'], :type => 'application/octet-stream', :disposition=>:attachment, :x_sendfile=>true
    end
end
