class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    flash.clear
    flash[:error] = exception.message
    respond_to do |f|
      f.js { render partial: 'shared/unauthorized', status: 401 }
    end
  end

  private

  def authenticate
    redirect_to new_user_session_path unless current_user
    flash[:error] = 'Please, log in or sign up to continue'
  end

  def flash_clear
    flash.clear
  end
end
