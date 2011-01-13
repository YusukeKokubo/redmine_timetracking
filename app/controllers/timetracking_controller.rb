class TimetrackingController < ApplicationController
  unloadable
  
  def index
	  @users = User.find(:all, :conditions => ["status = 1"])
	  
      from = params[:from] ? Date.parse(params[:from]) : Date.today - 4
      to = params[:to] ? Date.parse(params[:to]) : Date.today
      
	  @days = []
	  from.upto(to) do |n|
		  @days << n
	  end
	  
	  @time_entries = TimeEntry.find(:all,
									 :conditions => ["spent_on BETWEEN ? AND ?", @days.first, @days.last])
  end
  
  def user
	  @user = User.find(params[:user])
	  @users = [@user]
	  
      from = params[:from] ? Date.parse(params[:from]) : Date.today - 4
      to = params[:to] ? Date.parse(params[:to]) : Date.today
      
	  @days = []
	  from.upto(to) do |n|
		  @days << n
	  end
	  
	  @time_entries = TimeEntry.find(:all,
									 :conditions => ["user_id = ? AND spent_on BETWEEN ? AND ?", @user, @days.first, @days.last])
	  render :action => :index
  end

  def show
	  @user = User.find(params[:user])
	  @day = params[:day]
	  @time_entries = TimeEntry.find(:all,
									 :conditions => ["spent_on = ? AND user_id = ?", @day, @user])
  end
end
