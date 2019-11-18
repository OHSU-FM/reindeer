Rails.application.routes.draw do

  resources :usmle_exams
  get '/csl_feedbacks/index'
  get '/csl_feedbacks/get_csl_feedback'
  get '/csl_feedbacks/:cohort/:email/:block', action: :show, controller: "csl_feedbacks", to: "csl_feedbacks#show"

  get 'cds_reports', to: 'cds_reports#index'
  get 'cds_reports/past_due', to: 'cds_reports#past_due'
  get 'wba_graphs/index', to: 'wba_graphs#index'
  get 'wba_graphs/show', to: 'wba_graphs#show'
  get 'wba_graphs/get_entrustment_data', to: 'wba_graphs#get_entrustment_data'
  resources :epas
  resources :competencies do
    member do
      get '/competencies/:user_id', to: 'competecies#index', as: 'competency'
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

  get "pages/*id", to: "high_voltage/pages#show", as: :page, format: false

  #match "*any", via: :all, to: "errors#file_not_found"
end
