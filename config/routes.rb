ActionController::Routing::Routes.draw do |map|
  map.resources :hr_jobs
  map.resources :hr_candidates
  map.resources :hr_statuses
  map.resources :hr_members, :member => {:autocomplete_for_user => :get}  
end
