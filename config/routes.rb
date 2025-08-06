Rails.application.routes.draw do
  resources :precep_meetings
  resources :new_competencies do
    collection  do
      get 'competency_rpt', action: :competency_rpt, controller: 'new_competencies', to: 'new_competencies#competency_rpt'
      get 'download_file', param: :file_name, action: :download_file,  controller: 'new_competencies', to: 'new_competencies#download_file'
    end
  end
  resources :badging_dates
  resources :course_schedules
  resources :courses
  #get 'overall_progresses/index'
  resources :eg_members
  get 'fix_eg_members/index'
  get 'fix_eg_members/reviewer_update'
  get 'fix_eg_members/process_eg_file'
  get 'fix_eg_members/eg_assignment'
  get 'fix_eg_members/download_file'


  get 'reports/index'
  resources :fom_remeds
  resources :advisors

  resources :reports do
    collection do
      get 'download_file', param: :file_name, action: :download_file,  controller: 'reports', to: "reports#download_file"
      get 'competency', action: :competency, controller: 'reports', to: 'reports#competency'
      get 'mspe', action: :mspe, controller: 'reports', to: "reports#mspe"
    end
  end

  resources :events do
    collection do
      get 'create_batch_appointments', action: :create_batch_appointments, controller: 'events', to: 'events#create_batch_appointments'
      get 'create_random_appointments', to: 'events#create_random_appointments'
      get 'list_past_valid_appointments', action: :list_past_valid_appointments, controller: 'events', to: 'events#list_past_valid_appointments'
      get 'save_all', param: :appointments,  action: :save_all, controller: 'events', to: 'events#save_all'
      get 'save_all_random', param: :appointments,  action: :save_all_random, controller: 'events', to: 'events#save_all_random'
      get 'check_events', action: :check_events, controller: 'events', to: 'events#check_events'
      get 'resend_calendar_invite', action: :resend_calendar_invite, controller: 'events', to: 'events#resend_calendar_invite'
      get 'resend_invite', action: :resend_invite, controller: 'events', to: 'events#resend_invite'
      get 'batch_delete', action: :batch_delete, controller: 'events', to: 'events#batch_delete'
      get 'delete_all', action: :delete_all, controller: 'events', to: 'events#delete_all'
      get 'get_events_by_advisor', action: :get_events_by_advisor, controller: 'events', to: 'events#get_events_by_advisor'
      post 'calendly_click', action: :calendly_click, controller: 'events', to: 'events#calendly_click'
      get 'download_file', param: :file_name, action: :download_file,  controller: 'events', to: 'events#download_file'
      get 'get_ics_files', param: :ics_file, controller: 'events', to: 'events#get_ics_files'
      get 'purge_ics_files',  param: :ics_file, action: :purge_ics_files, to: 'events#purge_ics_files'
    end
  end
  #get 'student_assessments/index'
  resource :student_assessments, param: :slug, only: [:show]
  get '/student_assessments/search'

  get '/csl_feedbacks/index'
  get '/csl_feedbacks/get_csl_feedback'
  get '/csl_feedbacks/:cohort/:email/:block', action: :show, controller: "csl_feedbacks", to: "csl_feedbacks#show"
  get 'cds_reports', to: 'cds_reports#index'
  get 'wba_graphs/index', to: 'wba_graphs#index'
  get 'wba_graphs/wba_report', to: 'wba_graphs#wba_report'

  resources :epas

  resources :epa_reviews do
    collection do
      post 'local_storage'
    end
  end

  resources :epa_masters do
    collection  do
      get 'search_student'
      get 'eg_mismatch', action: :eg_report, controller: 'epa_masters', to: 'epa_masters#eg_mismatch'
      get 'eg_badged', action: :eg_report, controller: 'epa_masters', to: 'epa_masters#eg_badged'
      get 'epa_qa', controller: 'epa_masters', to: 'epa_masters#epa_qa'
      get 'wba_epa', action: :wba_epa, controller: 'epa_masters', to: 'epa_masters#wba_epa'
      get 'wba_clinical', action: :wba_clinical, controller: 'epa_masters', to: 'epa_masters#wba_clinical'
      get 'download_file', param: :file_name, action: :download_file,  controller: 'epa_masters', to: 'epa_masters#download_file'
      get 'badged_graph', action: :badged_graph, controller: 'epa_masters', to: 'epa_masters#badged_graph'
      get 'wba_epa_graph', action: :wba_epa_graph, controller: 'epa_masters', to: 'epa_masters#wba_epa_graph'
      get 'average_wba_epa', action: :average_wba_epa, controller: 'epa_masters', to: 'epa_masters#average_wba_epa'
      get 'query_ai', action: :query_ai, controller: 'epa_masters', to: 'epa_masters#query_ai'

    end

  end
  #get 'epa_masters/eg_report', controller: "epa_masters", action: :eg_report, to: "epa_masters#eg_report"
  resources :usmle_exams
  get '/csl_feedbacks/index'
  get '/csl_feedbacks/get_csl_feedback'
  get '/csl_feedbacks/:cohort/:email/:block', action: :show, controller: "csl_feedbacks", to: "csl_feedbacks#show"

  get 'cds_reports', to: 'cds_reports#index'
  get 'cds_reports/past_due', to: 'cds_reports#past_due'
  get 'cds_reports/by_subject', to: 'cds_reports#by_subject'
  get 'wba_graphs/index', to: 'wba_graphs#index'
  get 'wba_graphs/show', to: 'wba_graphs#show'
  get 'wba_graphs/get_entrustment_data', to: 'wba_graphs#get_entrustment_data'

  resources :user do
    resources :competencies, param: :user_id, only: [:index, :new]
    resources :overall_progresses, param: :user_id, only: [:index]
    resources :new_competencies, param: :user_id, only: [:index, :new]
  end

  resources :competencies, only: [:index, :new, :create, :destroy]

  resources :fom_exams do
    collection do
      get 'list_all_blocks', param: :id,  controller: 'fom_exams', to: 'fom_exams#list_all_blocks'
      get 'export_block', controller: 'fom_exams', to: 'fom_exams#export_block'
      get 'process_csv', param: :file_name, controller: 'fom_exams', to: 'fom_exams#process_csv'
      get 'process_fom', controller: 'fom_exams', action: :index, to: 'fom_exams#process_fom'
      get 'download_file', param: :file_name, action: :download_file,  controller: 'fom_exams', to: 'fom_exams#download_file'
      post 'send_alerts', controller: 'fom_exams', action: :send_alerts, to: 'fom_exams#send_alerts'
      get 'send_alerts', controller: 'fom_exams', action: :send_alerts, to: 'fom_exams#send_alerts'
      get 'display_fom', controller: 'fom_exams', action: :display_fom, to: 'fom_exams#display_fom'
      get 'unsubscribe'

    end
  end

  resources :preceptor_evals,  only: [:show], param: :uuid

  resources :artifacts do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
     member do
       delete :delete_document_attachment
       get 'move_files'
       get 'step_2_move_files'
       get 'process_preceptor_eval'
       get 'process_formative_feedback'
       get 'process_comp_excel'
       get 'process_bls_excel'
     end
     collection do
       get 'get_sub_components'
     end
  end
  namespace :coaching do
    resources :students, param: :slug, only: [:show] do
      member do
        post 'search_goals'
        post 'completed_goals'
        post 'search_meetings'
        post 'advisor_reports'
        post 'oasis_graphs'
        get 'contact_form'
        get  'file_download', param: :file_name, action: :file_download

      end
    end

    resources :goals do
      member do
        get 'show_detail'
      end
    end

    resources :meetings do
      member do
        get 'show_detail'
      end
    end
  end

  # resources :searches, param: :search, only: [:index] do
  #   member do
  #     get 'search'
  #   end
  # end

  get '/search' => 'searches#search', as: 'search_searches'
  get '/searches/download_file'

  resources :coaching, only: [:index]
  resources :rooms, only: [:show, :index]

  devise_for :users

  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  mount ActionCable.server => "/cable"

  resources :messages

  resources :dashboard, controller: :dashboard, as: :dashboards, except: [:new]
  get "dashboard/:id/widgets/:widget_id", to: "dashboard#show_widget",
   constraints: { id: /\d+/, widget_id: /\d+/ }, as: "show_widget"

  resources :question_widgets, only: [:create]
  get "question_widgets", controller: "question_widgets"

  resources :ls_reports, only: [:index, :show], param: :sid do
    member do
      get "filter(/:pk(/:agg))", action: :show, as: :filter, controller: "ls_reports/filter", to: "ls_reports/filter#show",
        constraints: { pk: /[^\/]+/, agg: /[^\/]+/ }, view_type: :filter
    end
    member do
      get "graph(/:pk(/:agg))", action: :show, as: :graph, controller: "ls_reports/graph", to: "ls_reports/graph#show",
        constraints: { pk: /[^\/]+/, agg: /[^\/]+/ }, view_type: :graph
    end
    member do
      get "spreadsheet(/:pk(/:agg))", action: :show, as: :spreadsheet, controller: "ls_reports/spreadsheet", to: "ls_reports/spreadsheet#show",
        constraints: { pk: /[^\/]+/, agg: /[^\/]+/ }, view_type: :spreadsheet
    end
    member do
      get "partial/:view_type/:gid(/:pk(/:agg))", to: "ls_reports/base#show_part", as: :part_of,
        constraints: { pk: /[^\/]+/, agg: /[^\/]+/, gid: /[^\/]+/ }
    end
  end

  #resources :users , controller: :users, param: :username, only: [:show, :update]
  resources :users do
    collection do
        get "update_loa", action: :update_loa, to: "users#update_loa#"
        get "save_update_loa", action: :save_update_loa, to: "users#save_update_loa"
        get "update_career_interests", action: :update_career_interests, to: "users#update_career_interests"
        get "save_career_interests", action: :save_career_interests, to: "users#save_career_interests"
    end
  end


  get "ls_files/:sid/:row_id/:qid/:name", to: "ls_files#show", constraints: { name: /[^\/]+/ }, as: :lime_file

  root to: "dashboard#index"

  #root to: redirect('/dashboard', status: 302)

  # Error routing
  get "errors/file_not_found"
  get "errors/unprocessable"
  get "errors/internal_server_error"
  get "errors/not_authorized"
  match "/401", to: "errors#not_authorized", via: :all
  match "/404", to: "errors#file_not_found", via: :all
  match "/422", to: "errors#unprocessable", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  #match '*unmatched', to: 'application#route_not_found', via: :all   # this will break the activestorage url_for(document) - make the document not viewable.

  get "pages/*id", to: "high_voltage/pages#show", as: :page, format: false

  #match "*any", via: :all, to: "errors#file_not_found"
end
