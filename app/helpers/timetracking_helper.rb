module TimetrackingHelper
	def time_entries_by_user(user, day)
		@time_entries.select {|time_entry| time_entry.user == user and time_entry.spent_on == day}
	end

	def class_hours(day, hours)
    return "saturday" if day.wday == 6
    return "sunday" if day.wday == 0
		return "no-hours" if hours.nil? or hours <= 0.0
		return "not-enough" if hours < 8.0
	end
	
	def link_to_usertrack(user, options={})
		return h(user.to_s) unless user.is_a?(User)
    name = h(user.name(options[:format]))
    return name unless user.active?
        
    link_to name, :controller => 'timetracking', :action => 'timelog', :user => user
	end

  def link_to_posttime(day, date, options={})
    link_to day, :controller => 'timetracking', :action => 'posttime', :date=> date
  end
	
	def param_user(user)
	    return "" unless user
	    "<input type=\"hidden\" name=\"user\" value=\"#{user.id}\">"
	end
end

