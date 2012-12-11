require 'redmine'

Redmine::Plugin.register :redmine_timetracking do
  name 'Redmine Timetracking Plugin'
  author 'Yusuke Kokubo'
  description 'This is a plugin for Redmine to show time tracking.'
  version '0.0.1'

  menu :top_menu,
       :timetracking,
       {:controller => 'timetracking',
        :action => 'index'},
       :caption => :timetracking
end
