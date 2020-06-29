class ApplicationController < ActionController::Base

  rescue_from CanCan::AccessDenied do |exception|
    flash.clear
    flash[:error] = exception.message
    respond_to do |f|
      f.js { render partial: 'shared/unauthorized', status: 401 }
    end
  end

end
