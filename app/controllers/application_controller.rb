# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?
  
    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
  
    def logged_in?
      current_user.present?
    end
  
    def require_login
      redirect_to login_path, alert: 'You must be logged in to access this page' unless logged_in?
    end
  end
  