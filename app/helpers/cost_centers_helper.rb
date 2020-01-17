module CostCentersHelper

  def get_selectable_cost_centers(entity_id=0, function=0, current_country)
    country_ids ||= [current_country]
    country_ids << Geography.record_all_countries.first.id

    CostCenter.active.selectable.available_for_country(country_ids).cost_centers_available(entity_id) +
        CostCenter.active.selectable.available_for_country(country_ids).associated_cost_centers(entity_id, function)
  end

  def get_selectable_cost_centers_per_function(entity_id=0, function=0, current_country)
    country_ids ||= [current_country]
    country_ids << Geography.record_all_countries.first.id
    # valid filter "selectable" for models CostCenter, Staff, Supplies
    CostCenter.active.selectable.available_for_country(country_ids).cost_centers_available(entity_id).with_function(function) +
        CostCenter.active.selectable.available_for_country(country_ids).associated_cost_centers(entity_id, function)
  end

  def header_cost_centers(cost_centers)
    html = ""
    cost_centers.each do |cost_center|
      html += "<td data-cost-center='#{cost_center.id}' data-function='#{cost_center.function}'><label>#{cost_center.description}</label></td>"
    end

    html
  end

end
