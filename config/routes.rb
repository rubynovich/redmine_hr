RedmineApp::Application.routes.draw do
  resources :hr_jobs
  resources :hr_candidates
  resources :hr_statuses
  resources :hr_adaptive_issues
  resources :hr_members do
    collection do
      get :autocomplete_for_user
    end
  end
end
