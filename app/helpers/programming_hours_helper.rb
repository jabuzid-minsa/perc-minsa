module ProgrammingHoursHelper

  def get_payroll(record)
    "#{record.dni}-#{record.name} #{record.labor_law.labor_standard.description}-#{record.labor_law.staff.description}"
  end

  # En analisis, cambiar en el futuro
  def acces_attribute_programming_hours(record, attribute='hours')
    if record.present?
      record[:"#{attribute}"]
    end
  end

  def find_hours_for_payroll(data, attribute, payroll, salary_component = nil, cost_center = nil, reponse_default = 0)
    if salary_component == nil
      response = data.select{|key, hash| key['payroll_id'] == payroll }
    else
      response = data.select{|key, hash| key['salary_component_id'] == salary_component and key['cost_center_id'] == cost_center and key['payroll_id'] == payroll }
    end
    
    response.present? ? response[0][attribute] : reponse_default
  end

  #
  def is_monetary_value(value)
    if value.to_i == 0
      t('app.texts.monetary_value')
    end
  end
end
