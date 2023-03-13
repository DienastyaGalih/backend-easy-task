Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v3 do
      post '/task_action/submit', to: 'task_action#submit'
      post '/run_work_flow/:config_work_flow_id', to: 'work_flow#run_workflow'
      options '/run_work_flow/:config_work_flow_id', to: 'work_flow#run_workflow'
      post '/form', to: 'form#submit'
      get '/form/:form_id', to: 'form#index'
      get '/work_flow/:work_flow_id', to: 'work_flow#index'
      get '/work_flow', to: 'work_flow#list'
    end
  end
end
