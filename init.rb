require 'redmine'
require 'dispatcher'
require 'user_patch'

Dispatcher.to_prepare do
  User.send(:include, HR) unless User.include? HR
end

Redmine::Plugin.register :redmine_hr do
  name 'Redmine HR plugin'
  author 'Roman Shipiev'
  description 'Redmine plugin for HR-managers'
  version '0.0.1'
  url 'http://github.com/rubynovich/redmine_hr'
  author_url 'http://roman.shipiev.me'

  menu :application_menu, :hr_statuses, 
    {:controller => :hr_statuses, :action => :index}, 
    :caption => :label_hr_statuse_plural, 
    :if => Proc.new{ User.current.is_hr? }
  menu :application_menu, :hr_jobs, 
    {:controller => :hr_jobs, :action => :index},
    :caption => :label_hr_job_plural, 
    :if => Proc.new{ User.current.is_hr? }
  menu :application_menu, :hr_candidates, 
    {:controller => :hr_candidates, :action => :index},
    :caption => :label_hr_candidate_plural, 
    :if => Proc.new{ User.current.is_hr? }
end
