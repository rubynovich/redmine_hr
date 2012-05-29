ActionController::Routing::Routes.draw do |map|
  map.resources :hr_jobs
  map.resources :hr_candidates
  map.resources :hr_statuses
end
