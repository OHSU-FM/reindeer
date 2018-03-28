Rails.application.routes.draw do

  devise_for :users
  mount RailsAdmin::Engine => "/admin", :as => "rails_admin"

  resources :dashboard, :controller=>:dashboard, :as=>:dashboards, :except=>[:new]
  get "dashboard/:id/widgets/:widget_id", :to=>"dashboard#show_widget", :constraints=>{:id=>/\d+/, :widget_id=>/\d+/}, :as=>"show_widget"

  resources :question_widgets, :only=>[:create]
  get "question_widgets", :controller=>"question_widgets"

  resources :ls_reports, :only=>[:index, :show], :param=>:sid do
    member do
      get "filter(/:pk(/:agg))", :action=>:show, :as=>:filter, :controller=>"ls_reports/filter",
        :constraints=>{:pk=>/[^\/]+/, :agg=>/[^\/]+/}, :view_type=>:filter
    end
    member do
      get "graph(/:pk(/:agg))", :action=>:show, :as=>:graph, :controller=>"ls_reports/graph",
        :constraints=>{:pk=>/[^\/]+/, :agg=>/[^\/]+/}, :view_type=>:graph
    end
    member do
      get "spreadsheet(/:pk(/:agg))", :action=>:show, :as=>:spreadsheet, :controller=>"ls_reports/spreadsheet",
        :constraints=>{:pk=>/[^\/]+/, :agg=>/[^\/]+/}, :view_type=>:spreadsheet
    end
    member do
      get "instrument(/:pk(/:agg))", :action=>:show, :as=>:instrument, :controller=>"ls_reports/instrument",
        :constraints=>{:pk=>/[^\/]+/, :agg=>/[^\/]+/}
    end
    member do
      get "partial/:view_type/:gid(/:pk(/:agg))", :to=>"ls_reports/base#show_part", :as=>:part_of,
        :constraints=>{:pk=>/[^\/]+/, :agg=>/[^\/]+/, :gid=>/[^\/]+/}
    end
  end

  resources :user, :controller=>:users, :param=>:username, :only=>[:show, :update]

  resources :comment_thread, only: :show do
    resources :comments, only: [:index, :create, :destroy]
  end

  namespace :assignment, path: Settings.assignments_route_name  do
    root to: "assignment_groups#index"
    resources :assignment_groups, param: :assignment_group_id, path: :groups, only: [:index, :show, :update] do
      resources :comments, module: :assignment_group, only: [:index, :create, :destroy]
    end
    resources :user_assignments, path: :tasks, only: [:show] do
      get "/fetch_compare" => "user_assignments#fetch_compare"
    end
    resources :user_responses, path: :responses, only: [:show] do
      resources :comments, module: :user_response, only: [:index, :create, :destroy]
      get "/set_owner_status" => "user_responses#set_owner_status"
    end
  end

  get "ls_files/:sid/:row_id/:qid/:name", :to=>"ls_files#show", :constraints=>{:name=>/[^\/]+/}, :as=>:lime_file

  root :to=>"dashboard#index"

  # Error routing
  get "errors/file_not_found"
  get "errors/unprocessable"
  get "errors/internal_server_error"
  get "errors/not_authorized"
  match "/401", to: "errors#not_authorized", via: :all
  match "/404", to: "errors#file_not_found", via: :all
  match "/422", to: "errors#unprocessable", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  get "pages/*id", to: "high_voltage/pages#show", :as => :page, :format => false

  match "*any", via: :all, to: "errors#file_not_found"

end
