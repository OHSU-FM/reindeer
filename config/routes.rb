Rails.application.routes.draw do

  resources :advisors

  resources :events do
    collection do
      get 'create_batch_appointments', action: :create_batch_appointments, controller: 'events', to: 'events#create_batch_appointments'
      get 'create_random_appointments', to: 'events#create_random_appointments'
      get 'save_all', param: :appointments,  action: :save_all, controller: 'events', to: 'events#save_all'
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
      get 'eg_mismatch', action: :eg_report, controller: 'eg_masters', to: 'epa_masters#eg_mismatch'
      get 'eg_badged', action: :eg_report, controller: 'eg_masters', to: 'epa_masters#eg_badged'
      get 'epa_qa', controller: 'eg_masters', to: 'epa_masters#epa_qa'
      get 'wba_epa', action: :wba_epa, controller: 'eg_masters', to: 'epa_masters#wba_epa'
      get 'download_file', param: :file_name, action: :download_file,  controller: 'epa_masters'
    end

  end
  #get 'epa_masters/eg_report', controller: "epa_masters", action: :eg_report, to: "epa_masters#eg_report"
  resources :courses
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
    resources :competencies, param: :user_id, only: [:index]
  end

  get 'fom_exams/list_all_blocks', controller: 'fom_exams', to: 'fom_exams#list_all_blocks'
  get '/fom_exams/export_block', controller: 'fom_exams', to: 'fom_exams#export_block'
  get '/fom_exams/process_csv', param: :file_name, controller: 'fom_exams', to: 'fom_exams#process_csv'
  get '/fom_exams/user', controller: 'fom_exams', action: 'index', to: 'fom_exams/user'
  get '/fom_exams/download_file', param: :file_name, action: :download_file,  controller: 'fom_exams'

  resources :user do
    resources :preceptor_evals,  only: [:index] do
    end
  end

  resource :fom_exams do
      collection do
        post 'send_alerts'
        get 'send_alerts'
        get 'display_fom'
        get 'unsubscribe'
      end
  end

  resources :artifacts do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
     member do
       delete :delete_document_attachment
       get 'move_files'
     end
  end
  namespace :coaching do
    resources :students, param: :slug, only: [:show] do
      member do
        post 'search_goals'
        post 'completed_goals'
        post 'search_meetings'
        post 'advisor_reports'
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
      get "filter(/:pk(/:agg))", action: :show, as: :filter, controller: "ls_reports/filter",
        constraints: { pk: /[^\/]+/, agg: /[^\/]+/ }, view_type: :filter
    end
    member do
      get "graph(/:pk(/:agg))", action: :show, as: :graph, controller: "ls_reports/graph",
        constraints: { pk: /[^\/]+/, agg: /[^\/]+/ }, view_type: :graph
    end
    member do
      get "spreadsheet(/:pk(/:agg))", action: :show, as: :spreadsheet, controller: "ls_reports/spreadsheet",
        constraints: { pk: /[^\/]+/, agg: /[^\/]+/ }, view_type: :spreadsheet
    end
    member do
      get "partial/:view_type/:gid(/:pk(/:agg))", to: "ls_reports/base#show_part", as: :part_of,
        constraints: { pk: /[^\/]+/, agg: /[^\/]+/, gid: /[^\/]+/ }
    end
  end

  resources :user, controller: :users, param: :username, only: [:show, :update]

  get "ls_files/:sid/:row_id/:qid/:name", to: "ls_files#show", constraints: { name: /[^\/]+/ }, as: :lime_file

  root to: "dashboard#index"

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
