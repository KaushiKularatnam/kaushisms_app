class ApplicationController < ActionController::Base

  before_filter :authorize # Only whitelisted methods allowed
  protect_from_forgery

  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_url, :notice => "Please log in"
    end
  end

  def admin_only
    if User.find_by_id(session[:user_id])
      unless User.find_by_id(session[:user_id]).admin?
        redirect_to login_url, :notice => "Please log in"
      end
    end
  end

end
