json.extract! user, :email, :full_name, :role, :geography_id, :state
json.url user_url(user, format: :json)