json.extract! labor_law, :id, :year, :month, :hours_max, :extra_hours, :max_extra_hours, :festive_hours, :max_festive_hours, :min_wage, :staff_id, :labor_standard_id, :contract_type_id, :entity_id, :created_at, :updated_at
json.url labor_law_url(labor_law, format: :json)