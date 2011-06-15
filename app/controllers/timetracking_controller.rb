class TimetrackingController < ApplicationController
  unloadable
  
  def index
	  @users = User.find(:all, :conditions => ["status = 1"])
	  
    from = params[:from] ? Date.parse(params[:from]) : Date.today - 6
    to = params[:to] ? Date.parse(params[:to]) : Date.today
    
	  @days = []
	  from.upto(to) do |n|
		  @days << n
	  end
    unless @days.size < 10 or User.current.admin?
      @time_entries = []
      return
    end
	  
	  @time_entries = TimeEntry.find(:all,
									 :conditions => ["spent_on BETWEEN ? AND ?", @days.first, @days.last])
  end
  
  def timelog
	  @user = User.find(params[:user])
	  
    from = params[:from] ? Date.parse(params[:from]) : Date.today - 4
    to = params[:to] ? Date.parse(params[:to]) : Date.today
      
	  @days = []
	  from.upto(to) do |n|
		  @days << n
	  end
	  
    @entries = TimeEntry.find(:all,
				:conditions => ["#{TimeEntry.table_name}.user_id = ? AND #{TimeEntry.table_name}.spent_on BETWEEN ? AND ?", @user.id, @days.first, @days.last],
				:include => [:activity, :project, {:issue => [:tracker, :status]}],
				:order => "#{TimeEntry.table_name}.spent_on DESC, #{Project.table_name}.name ASC, #{Tracker.table_name}.position ASC, #{Issue.table_name}.id ASC")
    @entries_by_day = @entries.group_by(&:spent_on)

	  render :action => 'timelog'
  end

  def show
	  @user = User.find(params[:user])
	  @day = params[:day]
	  @time_entries = TimeEntry.find(:all,
									 :conditions => ["spent_on = ? AND user_id = ?", @day, @user])
  end
end
