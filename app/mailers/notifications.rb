class Notifications < ActionMailer::Base
  def contact(email_params, sent_at = Time.now)
    subject "" << email_params[:subject]
    recipients "" << email_params[:client]
    from "#{email_params[:name]} <#{email_params[:address]}>"
    
    part "text/plain" do |p|
      p.part :content_type => "text/plain", :body => render("contact.erb")
    end
    
    @message = email_params[:body]
    

    attachments['invoice.pdf'] = File.read("#{Rails.root.to_s}/public#{email_params[:attach]}") unless email_params[:attach].blank?   
    
    sent_on sent_at

    mail(:to => email_params[:client],
         :from => email_params[:address],
         :subject => email_params[:subject]) do |format|
      format.html { render 'contact' }
      format.text { render :text => email_params[:body] }
    end
  end
end
