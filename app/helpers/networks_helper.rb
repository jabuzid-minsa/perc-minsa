module NetworksHelper

  def get_associated_networks
    if current_user.is_global_administrator? or current_user.is_level_one_manager?
      if current_user.is_valid_session_country?(session[:country_id])
        Network.active.available_for_country(Geography.find(session[:country_id]).numerical_code)
      elsif current_user.is_valid_geography?
        Network.active.available_for_country(current_user.geography.numerical_code)
      end
    else
      Network.active.for_users(current_user.id)
    end
  end

  def networks_for_country
    if current_user.is_valid_geography?
      country = Geography.find(current_user.geography_id).numerical_code
    elsif current_user.is_valid_session_country?(session[:country_id])
      country = Geography.find(session[:country_id]).numerical_code
    else
      country = 0
    end
    Network.joins(:geography).where(:geographies => { numerical_code: country })
  end

end
