class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Validation for auth users.
  before_action :authenticate_user!, :detect_idiom_browser

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, :alert => t('general_errors.texts.permission_denied') }
      format.json { render json: t('general_errors.texts.permission_denied').to_json, status: 403 }
    end
  end

  def url_root
    if current_user.is_global_administrator?
      redirect_to geographies_path
    else
      redirect_to edit_user_registration_path
    end
  end

  def detect_idiom_browser
    begin
      if not session[:language_user].present?
        idioms = Language.select(:abbreviation).active
        abbreviation_user = request.env['HTTP_ACCEPT_LANGUAGE'].split(',')[0].split(';')[0].sub('-', '_')
        if idioms.exists?(:abbreviation => abbreviation_user)
          session[:language_user] = abbreviation_user
        elsif idioms.exists?(:abbreviation => abbreviation_user.split('_')[0])
          session[:language_user] = abbreviation_user.split('_')[0]
        else
          session[:language_user] = I18n.default_locale
        end
      end

    rescue Exception => e
      session[:language_user] = I18n.default_locale
    end
    I18n.locale = session[:language_user]
  end

  def change_of_date_for_costs
    if not session[:country_id].present?
      session[:country_id] = current_user.geography_id
    end
    session[:year] = params[:year]
    session[:month] = params[:month]
    render :json => t('app.change_date').to_json, :status => 200
  end

end
