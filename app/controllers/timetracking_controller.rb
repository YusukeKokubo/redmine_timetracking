class TimetrackingController < ApplicationController
  unloadable

  helper :issues
  include TimelogHelper
  helper :custom_fields
  include CustomFieldsHelper
  
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
	  
    # time entries
    @entries = TimeEntry.find(:all,
				:conditions => ["#{TimeEntry.table_name}.user_id = ? AND #{TimeEntry.table_name}.spent_on BETWEEN ? AND ?", @user.id, @days.first, @days.last],
				:include => [:activity, :project, {:issue => [:tracker, :status]}],
				:order => "#{TimeEntry.table_name}.spent_on DESC, #{Project.table_name}.name ASC, #{Tracker.table_name}.position ASC, #{Issue.table_name}.id ASC")
    @entries_by_day = @entries.group_by(&:spent_on)

    # activities
    @activity = Redmine::Activity::Fetcher.new(User.current, :project => nil, 
                                                             :with_subprojects => nil, 
                                                             :author => @user)
    @activity.scope = :all

    @events = @activity.events(from, to + 1)
    @events_by_day = @events.group_by(&:event_date)

    @all_days = (@entries_by_day.keys + @events_by_day.keys).uniq.sort.reverse

	  render :action => 'timelog'
  end

  def show
	  @user = User.find(params[:user])
	  @day = params[:day]
	  @time_entries = TimeEntry.find(:all,
									 :conditions => ["spent_on = ? AND user_id = ?", @day, @user])
  end

  def posttime
    @issues = Issue.open.find(:all, :conditions => ["assigned_to_id = ?", params[:user]])
    @issues_by_project = @issues.group_by(&:project)
  end
end
