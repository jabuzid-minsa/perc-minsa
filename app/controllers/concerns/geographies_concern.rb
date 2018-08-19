module GeographiesConcern extend ActiveSupport::Concern

  def get_model_by_country_allowed(model)
    country_ids = [Geography.record_all_countries.first.id]
    if current_user.is_valid_geography?
      country_ids << current_user.geography_id
    elsif current_user.is_valid_session_country?(session[:country_id])
      country_ids << session[:country_id]
    elsif can? :view_all_countries, Geography
      return model.all
    end
    model.where(geography_id: country_ids)
  end

  def get_country_valid_by_user(attribute='id')
    if current_user.is_valid_session_country?(session[:country_id])
      Geography.find(session[:country_id])[:"#{attribute}"]
    elsif current_user.is_valid_geography?
      current_user.geography[:"#{attribute}"]
    end
  end

end