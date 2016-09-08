Rails.application.routes.draw do

  devise_for :users
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resource :settings do
    resources :sync_triggers, except: [:update], controller: 'settings/sync_triggers'
    get 'users', to: 'settings#show_users', as: :users
    get 'surveys', to: 'settings#show_lime_surveys', as: :surveys
    get 'permissions_groups', to: 'settings#show_permissions_groups', as: :permissions_groups
    get Settings.assignments_route_name, to: 'settings#show_assignments', as: :assignments
  end

  resources :dashboard, :controller=>:dashboard, :as=>:dashboards, :except=>[:new]
  get 'dashboard/:id/widgets/:widget_id', :to=>'dashboard#show_widget', :constraints=>{:id=>/\d+/, :widget_id=>/\d+/}, :as=>'show_widget'

  resources :charts

  resources :question_widgets, :only=>[:create]
  get 'question_widgets', :controller=>'question_widgets'


  resources :data, :only=>[:index], :controller=>:reports, :as=>:reports
  get 'data/:id/:type', :to=>'reports#show', :via => [:get], :constraints=>{:id=>/[A-N]/}, :as=>'show_report'

  resources :reports, :only=>[:index], :controller=>:stats, :as=>:stats
  get 'reports/:id/:year', :to=>'stats#show', :via => [:get], :constraints=>{:year=> /\d\d\d\d/, :id=>/[0A-N]/}, :as=>'show_stat'

  resources :ls_reports, :only=>[:index, :show], :param=>:sid do
    member do
      get 'filter(/:pk(/:agg))', :action=>:show, :as=>:filter, :controller=>'ls_reports/filter',
        :constraints=>{:pk=>/[^\/]+/, :agg=>/[^\/]+/}, :view_type=>:filter
    end
    member do
      get 'graph(/:pk(/:agg))', :action=>:show, :as=>:graph, :controller=>'ls_reports/graph',
        :constraints=>{:pk=>/[^\/]+/, :agg=>/[^\/]+/}, :view_type=>:graph
    end
    member do
      get 'spreadsheet(/:pk(/:agg))', :action=>:show, :as=>:spreadsheet, :controller=>'ls_reports/spreadsheet',
        :constraints=>{:pk=>/[^\/]+/, :agg=>/[^\/]+/}, :view_type=>:spreadsheet
    end
    member do
      get 'instrument(/:pk(/:agg))', :action=>:show, :as=>:instrument, :controller=>'ls_reports/instrument',
        :constraints=>{:pk=>/[^\/]+/, :agg=>/[^\/]+/}
    end
    member do
      get 'partial/:view_type/:gid(/:pk(/:agg))', :to=>'ls_reports/base#show_part', :as=>:part_of,
        :constraints=>{:pk=>/[^\/]+/, :agg=>/[^\/]+/, :gid=>/[^\/]+/}
    end
  end

  resources :user, :controller=>:users, :param=>:username, :only=>[:show, :update] do
    member do
      get Settings.assignments_route_name,
        :to=>'users/assignment_group#show', :as=>:assignments_for
    end
  end

  namespace :assignment, path: Settings.assignments_route_name  do
    root to: 'assignment_groups#index'
    resources :assignment_group_templates, as: :templates, path: :templates
    resources :assignment_groups, param: :assignment_group_id, path: :groups do
      resources :comments, module: :assignment_group, only: [:index, :create, :destroy]
    end
    resources :user_assignments, path: :tasks do
      get "/fetch_compare" => "user_assignments#fetch_compare"
    end
    resources :user_responses, path: :responses, only: [:index, :show] do
      resources :comments, module: :user_response, only: [:index, :create, :destroy]
      get "/set_owner_status" => "user_responses#set_owner_status"
    end
    resources :survey_assignments, path: :forms, param: :survey_assignment_id
  end

  get 'ls_files/:sid/:row_id/:qid/:name', :to=>'ls_files#show', :constraints=>{:name=>/[^\/]+/}, :as=>:lime_file

  root :to=>'dashboard#index'

  # Error routing
  get 'errors/file_not_found'
  get 'errors/unprocessable'
  get 'errors/internal_server_error'
  get 'errors/not_authorized'
  match '/401', to: 'errors#not_authorized', via: :all
  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  get 'pages/*id', to: 'high_voltage/pages#show', :as => :page, :format => false

  match "*any", via: :all, to: "errors#file_not_found"

end
