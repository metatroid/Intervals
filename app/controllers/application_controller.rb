class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_timezone
  
  def set_timezone
    if current_user
      Time.zone = current_user.timezone.blank? ? "Pacific Time (US & Canada)" : current_user.timezone
    end
  end
end
