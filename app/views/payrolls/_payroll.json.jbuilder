json.extract! payroll, :id, :dni, :name, :salary, :labor_law_id, :entity_id, :created_at, :updated_at
json.url payroll_url(payroll, format: :json)