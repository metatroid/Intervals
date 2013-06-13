class IntervalsController < ApplicationController
  def create
    @user = current_user
    @project = @user.projects.find(params[:projectId])
    @method = params[:method]
    if @method == "timer"
      @interval = @project.intervals.create! do |i|
        i.project_id = params[:projectId]
        i.start = params[:start].blank? ? "0" : params[:start]
        i.end = params[:start].blank? ? "0" : params[:start]
        i.total = params[:total].blank? ? "0" : params[:total]
      end
    else
      @interval = @project.intervals.create! do |i|
        i.project_id = params[:projectId]
        i.start = params[:start].blank? ? "0" : params[:start]
        i.end = params[:start].blank? ? "0" : params[:start]
        i.total = params[:minutes].blank? ? "0" : params[:minutes]
        i.description = params[:description].blank? ? "Design/development" : params[:description]
      end
      previousTime = @project.total_time.blank? ? "0" : @project.total_time.to_s 
      totalTime = (previousTime.to_i) + (@interval.total.to_i)
      @project.update_attribute(:total_time,  totalTime)
      balance = "%.2f" % (@project.projectfee.to_i - ((totalTime.to_f/60) * @project.rate.to_i))
      @project.update_attribute(:projectbalance, balance)
      amount = "%.2f" % (((totalTime.to_f/60) * @project.rate.to_i) - (@project.project_paid.blank? ? 0 : @project.project_paid.to_f))
      @project.update_attribute(:project_amount, amount)
    end
    @projects = @user.projects.find(:all, :order => 'updated_at DESC')
  end

  def update
    @user = current_user
    @project = @user.projects.find(params[:projectId])
    @method = params[:method]
    @flag = params[:flag].blank? ? "started" : params[:flag]
    if @flag != "running"
      if @method != "manual"
        if params[:description].blank?
          #begginingTimestamp = @project.intervals.find(params[:intervalId]).start.gsub(/.*\(|.$/, '')
          #ending = params[:end]
          #endingTimestamp = ending.gsub(/.*\(|.$/, '')
        
          #difference = ((endingTimestamp.to_f - begginingTimestamp.to_f)/1000/60).to_i.to_s
          #previousTime = @project.total_time.blank? ? "0" : @project.total_time.to_s 
          #totalTime = (previousTime.to_i) + (difference.to_i)
          #@project.update_attribute(:total_time,  totalTime)
          #@project.intervals.find(params[:intervalId]).update_attributes(:end => ending, :total => difference)
          @interval = @project.intervals.find(params[:intervalId])
          @saved = false
        else
          @project.intervals.find(params[:intervalId]).update_attribute(:description, params[:description])
          @interval = @project.intervals.find(params[:intervalId])
          @saved = true
        end
      else
        @project.intervals.find(params[:intervalId]).update_attribute(:description,  params[:description]) unless params[:description].blank?
        @project.intervals.find(params[:intervalId]).update_attribute(:total, params[:time]) unless params[:time].blank?
        #previousTime = @project.total_time.blank? ? "0" : @project.total_time.to_s 
        #newTime = params[:time].blank? ? "0" : params[:time].to_i
        #totalTime = (previousTime.to_i) + newTime.to_i
        totalTime = 0
        @project.intervals.each do |i|
          totalTime += i.total.to_i
        end
        @project.update_attribute(:total_time,  totalTime)
        balance = "%.2f" % (@project.projectfee.to_i - ((totalTime.to_f/60) * @project.rate.to_i))
        @project.update_attribute(:projectbalance, balance)
        amount = "%.2f" % (((totalTime.to_f/60) * @project.rate.to_i) - (@project.project_paid.blank? ? 0 : @project.project_paid.to_f))
        @project.update_attribute(:project_amount, amount)
        @interval = @project.intervals.find(params[:intervalId])
      end
    else
      begginingTimestamp = @project.intervals.find(params[:intervalId]).start.gsub(/.*\(|.$/, '')
      ending = params[:end]
      endingTimestamp = ending.gsub(/.*\(|.$/, '')
    
      difference = ((endingTimestamp.to_f - begginingTimestamp.to_f)/1000/60).to_i.to_s
      previousTime = @project.total_time.blank? ? "0" : @project.total_time.to_s 
      totalTime = (previousTime.to_i) + 1
      @project.update_attribute(:total_time,  totalTime)
      balance = "%.2f" % (@project.projectfee.to_i - ((totalTime.to_f/60) * @project.rate.to_i))
      @project.update_attribute(:projectbalance, balance)
      amount = "%.2f" % (((totalTime.to_f/60) * @project.rate.to_i) - (@project.project_paid.blank? ? 0 : @project.project_paid.to_f))
      @project.update_attribute(:project_amount, amount)
      @project.intervals.find(params[:intervalId]).update_attribute(:description,  params[:description])
      @project.intervals.find(params[:intervalId]).update_attributes(:end => ending, :total => difference)
      @interval = @project.intervals.find(params[:intervalId])
      @saved = false
    end
    @projects = @user.projects.find(:all, :order => 'updated_at DESC')
  end
  def destroy
    @method = params[:method]
    @user = current_user
    @project = @user.projects.find(params[:projectId])
    previousTime = @project.total_time.blank? ? "0" : @project.total_time.to_s 
    instanceInterval = current_user.projects.find(params[:projectId]).intervals.find(params[:intervalId]).total
    newTime = (previousTime.to_f - instanceInterval.to_f).to_i.to_s
    @project.update_attribute(:total_time,  newTime)
    balance = "%.2f" % (@project.projectfee.to_i - ((newTime.to_f/60) * @project.rate.to_i))
    @project.update_attribute(:projectbalance, balance)
    amount = "%.2f" % (((newTime.to_f/60) * @project.rate.to_i) - (@project.project_paid.blank? ? 0 : @project.project_paid.to_f))
    @project.update_attribute(:project_amount, amount)
    @interval = current_user.projects.find(params[:projectId]).intervals.find(params[:intervalId]).destroy
    @projects = @user.projects.find(:all, :order => 'updated_at DESC')
  end
end
