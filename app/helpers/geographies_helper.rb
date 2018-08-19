module GeographiesHelper
  #
  def get_current_country_id
    if current_user.is_valid_geography?
      current_user.geography_id
    elsif current_user.is_valid_session_country?(session[:country_id])
      session[:country_id]
    end
  end

  #
  def get_country_ids
    country_ids ||= [id_for_all_countries]
    if current_user.is_valid_geography?
      country_ids << current_user.geography_id
    elsif current_user.is_valid_session_country?(session[:country_id])
      country_ids << session[:country_id]
    end
    return country_ids
  end

  #
  def id_for_all_countries
    Geography.where(numerical_code: 0).first.id
  end

  #
  def get_available_country(record)
    country_ids ||= [id_for_all_countries]
    country_ids << get_country_for_element(record)
  end

  #
  def get_country_for_element(record, attribute = 'id')
    country ||= 1
    if record.present? and record.geography_id.present?
      if attribute == 'description' && country == 1
        return t('app.texts.all_countries')
      else
        return Geography.find_by_numerical_code(record.geography.numerical_code)[:"#{attribute}"]
      end
    elsif current_user.is_valid_geography?
      country = current_user.geography_id
    elsif current_user.is_valid_session_country?(session[:country_id])
      country = session[:country_id]
    end
    if attribute == 'description' && country == 1
      t('app.texts.all_countries')
    else
      Geography.find(country)[:"#{attribute}"]
    end
  end

  #
  def get_id_country_for_user
    if current_user.is_valid_geography? or current_user.is_valid_session_country?(session[:country_id])
      if current_user.is_valid_geography?
        current_user.geography_id
      elsif current_user.is_valid_session_country?(session[:country_id])
        session[:country_id]
      end
    else
      1
    end
  end

  #
  def get_name_country_for_user
    if current_user.is_valid_geography? or current_user.is_valid_session_country?(session[:country_id])
      if current_user.is_valid_geography?
        Geography.find(current_user.geography_id).description
      elsif current_user.is_valid_session_country?(session[:country_id])
        Geography.find(session[:country_id]).description
      end
    else
      t('app.texts.all_countries')
    end
  end

  #
  def get_name_country(country_id)
    if country_id.present? and country_id > 0
      country = Geography.find(country_id)
      if country.first_level == '0'
        t('app.texts.all_countries')
      else
        country.description
      end
    else
      t('app.texts.all_countries')
    end
  end

  #
  def headers_depth_detail(headers=[], country_depth_detail=0)
    valid_headers = []
    count = 1
    headers.each do |header|
      if country_depth_detail >= count
        valid_headers << header
      end
      count = count + 1
    end
    return valid_headers
  end

  #
  def get_array_levels(country_depth_detail=0)
    levels = ['first_level', 'second_level', 'third_level', 'fourth_level', 'fifth_level']
    final_levels = []
    depth = country_depth_detail - 1
    (1..depth).each do |i|
      final_levels << levels[i]
    end
    return final_levels
  end

  #
  def get_name_levels(country_depth_detail=0)
    levels = ['first_level', 'second_level', 'third_level', 'fourth_level', 'fifth_level']
    name_levels = {}
    depth = country_depth_detail - 1
    (1..depth).each do |i|
      name_levels[levels[i]] = Geography.human_attribute_name(levels[i])
    end
    return name_levels
  end

  #
  def get_available_countries
    if current_user.is_global_administrator?
      all_countries = Geography.record_all_countries
      all_countries[0].description = t('app.texts.all_countries')
      all_countries +
          Geography.active.countries
    elsif current_user.is_valid_geography?
      Geography.active.where(id: name_current_user.geography_id)
    end
  end

=begin
  **********************************************************************************************************************
  ************************************ Helpers related to the model of geographies *************************************
  **********************************************************************************************************************
=end

  # Get record "all countries"
  def get_record_all_countries
    record = Geography.get_record_of_all_countries
    record[0].description = t('app.texts.all_countries')
    record
  end

  # Get variable session or cookie created with the selected country, this option is only useful for users who have the option "all countries"
  def get_variable_country
    session[:country_id]
  end

  # Validate if the record is "all countries"
  def is_all_countries?(record)
    if record.present? and record.numerical_code == 0
      record.description = t('app.texts.all_countries')
    end
    record
  end

  # List of countries for selection tags
  def list_of_countries
    if current_user.is_global_administrator?
      get_record_all_countries +
          Geography.active.countries
    elsif current_user.is_valid_geography?
      Geography.active.where(id: name_current_user.geography_id)
    end
  end

  # Get a specific attribute of the geography model
  def get_attribute_geography(record=nil, attribute='id')
    if record.present? and record.geography_id.present?
      geography = Geography.find(record.geography_id)
    elsif current_user.is_valid_session_country?(get_variable_country)
      geography = Geography.find(get_variable_country)
    elsif current_user.is_valid_geography?
      geography = Geography.find(current_user.geography_id)
    else
      geography = Geography.get_record_of_all_countries.first
    end
    is_all_countries?(geography)[:"#{attribute}"]
  end
end
