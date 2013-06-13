class ProjectsController < ApplicationController
  require 'fileutils'
  def create
    @user = current_user
    @project = @user.projects.create(params[:project])
    if @project.save
      flash[:notice] = ""
    else
      flash[:notice] = ""
    end
    @projects = @user.projects.find(:all, :order => 'updated_at DESC')
    @ongoing = @user.projects.where(:completed => false).order("updated_at DESC")
    @completed = @user.projects.where(:completed => true).order("updated_at DESC")
  end
  def update
    
  end
  def destroy
    @user = current_user
    @project = current_user.projects.find(params[:projectId])
    @project.destroy
  end
  
  def update
    @user = current_user
    @project = @user.projects.find(params[:id])
    @project.update_attributes(params[:project])
    balance = "%.2f" % (@project.projectfee.to_i - ((@project.total_time.to_f/60) * @project.rate.to_i))
    @project.update_attribute(:projectbalance, balance)
    amount = "%.2f" % (((@project.total_time.to_f/60) * @project.rate.to_i))
    hpaid = "%.2f" % (@project.project_amount.blank? ? amount.to_f - params[:paid].to_f : @project.project_amount.to_f - params[:paid].to_f)
    fpaid = "%.2f" % (@project.project_remainder.blank? ? @project.projectfee.to_f - params[:paid].to_f : @project.project_remainder.to_f - params[:paid].to_f)
    tpaid = "%.2f" % (@project.project_paid.blank? ? 0 + params[:paid].to_f : @project.project_paid.to_f + params[:paid].to_f)
    @project.update_attribute(:project_amount, hpaid)
    @project.update_attribute(:project_remainder, fpaid)
    @project.update_attribute(:project_paid, tpaid)
    @projects = @user.projects.find(:all, :order => 'updated_at DESC')
    @ongoing = @user.projects.where(:completed => false).order("updated_at DESC")
    @completed = @user.projects.where(:completed => true).order("updated_at DESC")
  end
  
  def actions
    id = params[:projectId]
    @action = params[:projectAction]
    @callback = params[:callbackFunction].blank? ? "nothing" : params[:callbackFunction]
    @invoiceId = params[:callbackFunction].gsub(/.+?(_)/, "") unless params[:callbackFunction].blank?
    @user = current_user
    if id != "0"
      @project = @user.projects.find(id)
      @intervals = @project.intervals.all
      @invoices = @project.invoices.all
      @invoiceCount = @invoices.length + 1
    end
    @projects = @user.projects.find(:all, :order => 'updated_at DESC')
    @ongoing = @user.projects.where(:completed => false).order("updated_at DESC")
    @completed = @user.projects.where(:completed => true).order("updated_at DESC")
  end
  
  def send_mail
    Notifications.deliver_contact(params[:email])
    redirect_to "/mail/success"
    #Notifications.contact(params[:email]).deliver
  end
  def mail_callback
    
  end
  
  
end
