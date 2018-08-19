module EntitiesHelper

  def get_associated_entities
    if current_user.is_global_administrator? or current_user.is_level_three_manager?
      if current_user.is_valid_session_country?(session[:country_id])
        Entity.active.available_for_country(Geography.find(session[:country_id]).numerical_code)
      elsif current_user.is_valid_geography?
        Entity.active.available_for_country(current_user.geography.numerical_code)
      end
    else
      Entity.active.for_users(current_user.id)
    end
  end

  def entities_by_geography(attribute='numerical_code', attribute_value=0)
    Entity.joins(:geography).where(:geographies => { "#{attribute}": attribute_value })
  end

  def entities_for_country
    if current_user.is_valid_geography?
      country = Geography.find(current_user.geography_id).numerical_code
    elsif current_user.is_valid_session_country?(session[:country_id])
      country = Geography.find(session[:country_id]).numerical_code
    else
      country = 0
    end
    if current_user.is_global_administrator?
      if country == 0
        Entity.active
      else
        Entity.joins(:geography).where(:geographies => { numerical_code: country })  
      end
    else
      Entity.joins(:geography).where(:geographies => { numerical_code: country })
    end
    
  end

end
