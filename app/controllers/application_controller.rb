class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_locale
  
  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  def authorize
    redirect_to login_url, alert: "Not authorized" if current_user.nil?
  end

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present? || I18n.default_locale
  end

  def default_url_options(options = {})
    { :locale => I18n.locale == I18n.default_locale ? nil : I18n.locale  }
  end


end
