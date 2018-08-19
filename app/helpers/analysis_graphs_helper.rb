module AnalysisGraphsHelper

  def calculate_hour_value(record, working_hour)
    benefits = ((record.payroll.benefits / working_hour) * record.hours)
    bonuses = ((record.payroll.bonuses / working_hour) * record.hours)
    hour_value = record.payroll.salary / working_hour
    rate = record.salary_component.rate > 1 ? record.salary_component.rate / 100 : 0

    ((hour_value + (hour_value * rate)) * record.hours) + benefits + bonuses
  end

  def calculate_overheads(record, total_of_record)
    total_value = total_of_record.select{ |id, sum| sum }[record.supply_id]
    if record.type_distribution.code.to_i != 4
      (record.general_value * ((record.value * 100) / total_value)) / 100
    else
      record.value
    end
  end

  def get_value_for_hash_human_resources(hash, cost_center, staff = nil)
    if staff == nil
      sum = hash.select{|key, hash| key['cost_center'] == cost_center }
          .map { |h| h.values_at("value") }
          .transpose.map { |v| v.compact.inject(:+) }[0]
    else
      sum = hash.select{|key, hash| key['staff'] == staff and key['cost_center'] == cost_center }
          .map { |h| h.values_at("value") }
          .transpose.map { |v| v.compact.inject(:+) }[0]
    end
    sum.present? ? sum.round(2) : 0
  end

   def get_attribute_for_hash_human_resources(hash, cost_center, attribute = "value")
    sum = hash.select{|key, hash| key['cost_center'] == cost_center }
          .map { |h| h.values_at(attribute) }
          .transpose.map { |v| v.compact.inject(:+) }[0]

    sum.present? ? sum.round(2) : 0
  end

  def get_value_for_hash_overheads_supplies(hash, cost_center, supply = nil)
    if supply == nil
      sum = hash.select{|key, hash| key['cost_center'] == cost_center }
                .map { |h| h.values_at("value") }
                .transpose.map { |v| v.compact.inject(:+) }[0]
    else
      sum = hash.select{|key, hash| key['supply'] == supply and key['cost_center'] == cost_center }
                .map { |h| h.values_at("value") }
                .transpose.map { |v| v.compact.inject(:+) }[0]
    end
    sum.present? ? sum.round(2) : 0
  end

  def get_data_by_cost_center(hash, cost_center, supported_cost_center, attribute = "value")
    sum = hash.select{|key, hash| key['cost_center_id'] == cost_center and key['supported_cost_center_id'] == supported_cost_center}
          .map { |h| h.values_at(attribute) }
          .transpose.map { |v| v.compact.inject(:+) }[0]

    sum.present? ? sum.round(0) : 0
  end

  def get_hours_for_efficiency_hours(hash, cost_center, staff)
    hour = 0
    data_filter = hash.select {|record| record['cost_center'] == cost_center && record['staff'] == staff }

    if data_filter.count > 0
      hour = data_filter[0]['hours']
    end

    return hour
  end

  def get_data_center_efficiency_hours(hash, cost_center, attribute)
    data_filter = hash.select {|record| record['cost_center'] == cost_center}
    
    if data_filter.count > 0
      data_filter[0][attribute]
    else
      ''
    end
  end

  def calculate_efficiency(production_has, hours_hash, cost_center, staff)
    total_hours = get_hours_for_efficiency_hours(hours_hash, cost_center, staff)
    production = get_data_center_efficiency_hours(production_has, cost_center, 'value')

    if production.to_f > 0
      (total_hours / production).round(2)
    else
      0
    end
  end
end
