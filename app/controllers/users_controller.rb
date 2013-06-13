class UsersController < ApplicationController
  def home
    @user = current_user
    if @user.blank?
      redirect_to root_path
    else
      @project = Project.new
      @projects = @user.projects.find(:all, :order => 'updated_at DESC')
    end
  end
  def update
    @user = current_user
    @user.update_attribute(:name, params[:user][:name]) unless params[:user][:name].blank?
    @user.update_attribute(:email, params[:user][:email]) unless params[:user][:email].blank?
    @user.update_attribute(:password, params[:user][:password]) unless params[:user][:password].blank?
    @user.update_attribute(:phone, params[:user][:phone]) unless params[:user][:phone].blank?
    @user.update_attribute(:businessphone, params[:user][:businessphone]) unless params[:user][:businessphone].blank?
    @user.update_attribute(:address1, params[:user][:address1]) unless params[:user][:address1].blank?
    @user.update_attribute(:address2, params[:user][:address2]) unless params[:user][:address2].blank?
    @user.update_attribute(:timezone, params[:user][:timezone]) unless params[:user][:timezone].blank?
    @user.update_attribute(:userlogo, params[:user][:userlogo]) unless params[:user][:userlogo].blank?
    
    @projects = @user.projects.find(:all, :order => 'updated_at DESC')
    @ongoing = @user.projects.where(:completed => false).order("updated_at DESC")
    @completed = @user.projects.where(:completed => true).order("updated_at DESC")
  end
end
