if Rails::VERSION::MAJOR >= 3
  RedmineApp::Application.routes.draw do
    resources :hr_jobs
    resources :hr_candidates
    resources :hr_statuses
    resources :hr_adaptive_issues
    resources :hr_members
  end
else
  ActionController::Routing::Routes.draw do |map|
    map.resources :hr_jobs
    map.resources :hr_candidates
    map.resources :hr_statuses
    map.resources :hr_adaptive_issues
    map.resources :hr_members
  end
end
