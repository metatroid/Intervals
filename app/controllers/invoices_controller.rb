class InvoicesController < ApplicationController
  require 'fileutils'
  def create
    @user = current_user
    @project = @user.projects.find(params[:projectId])
    content = params[:contents].gsub("/images", "#{Rails.root.to_s}/public/images").gsub("/uploads", "#{Rails.root.to_s}/public/uploads")
    @invoice = @project.invoices.create! do |i|
      i.project_id = params[:projectId]
      i.contents = content
    end
    @invoice.update_attribute(:pdf_url, "/invoices/user/#{@user.email}/project/#{@project.id.to_s}/invoice/#{@invoice.id.to_s}/#{@project.name}.pdf")
    FileUtils.mkdir_p "#{Rails.root.to_s}/public/invoices/user/#{@user.email}/project/#{@project.id.to_s}/invoice/#{@invoice.id.to_s}"
    kit = PDFKit.new("<html><head></head><body><div class='pdf'>#{@invoice.contents}</div></body></html>")
    kit.stylesheets = "#{Rails.root.to_s}/public/stylesheets/invoice.css"
    kit.to_file("#{Rails.root.to_s}/public/invoices/user/#{@user.email}/project/#{@project.id.to_s}/invoice/#{@invoice.id.to_s}/#{@project.name}.pdf")
  end
  
  def actions
    @action = params[:invoiceAction]
    @user = current_user
    @project = @user.projects.find(params[:projectId])
    @invoice = @project.invoices.find(params[:invoiceId])
    if @action.blank?
      redirect_to @invoice.pdf_url
    end
  end
  
  def destroy
    @user = current_user
    @project = @user.projects.find(params[:projectId])
    @invoice = @project.invoices.find(params[:invoiceId])
    @invoice.destroy
    FileUtils.rm_rf "#{Rails.root.to_s}/public/invoices/user/#{@user.email}/project/#{@project.id.to_s}/invoice/#{@invoice.id.to_s}"
  end
end
