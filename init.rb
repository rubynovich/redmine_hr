require 'redmine'

Redmine::Plugin.register :redmine_hr do
  name 'HR'
  author 'Roman Shipiev'
  description 'Plugin automates the interview, hire and adaptation of new employees'
  version '0.2.4'
  url 'https://bitbucket.org/rubynovich/redmine_hr'
  author_url 'http://roman.shipiev.me'

  menu :application_menu, :hr_candidates,
    {:controller => :hr_candidates, :action => :index},
    :caption => :label_hr_candidate_plural,
    :if => Proc.new{ User.current.is_hr? }
#  menu :application_menu, :hr_statuses,
#    {:controller => :hr_statuses, :action => :index},
#    :caption => :label_hr_status_plural,
#    :if => Proc.new{ User.current.is_hr? }
#  menu :application_menu, :hr_jobs,
#    {:controller => :hr_jobs, :action => :index},
#    :caption => :label_hr_job_plural,
#    :if => Proc.new{ User.current.is_hr? }

  menu :admin_menu, :hr_adaptive_issues,
    {:controller => :hr_adaptive_issues, :action => :index},
    :caption => :label_hr_adaptive_issue_plural,
    :if => Proc.new{ User.current.is_hr? },
    :html => {:class => :enumerations}
  menu :admin_menu, :hr_members,
    {:controller => :hr_members, :action => :index}, :caption => :label_hr_member_plural, :html => {:class => :users}
end

Rails.configuration.to_prepare do

  [:user].each do |cl|
    require "hr_#{cl}_patch"
  end

  require_dependency 'hr_candidate'
  require 'time_period_scope'

  [
   [User, HRPlugin::UserPatch],
   [HrCandidate, TimePeriodScope]
  ].each do |cl, patch|
    cl.send(:include, patch) unless cl.included_modules.include? patch
  end

end
