Rails.application.routes.draw do
	#
	scope 'multiple_months', prefix: 'multiple_months' do		
		post 'analysis/consumption_centers_support', to: 'multiple_analysis#data_consumption', as: 'multiple_data_consumption'
		get 'analysis/consumption_centers_support', to: 'multiple_analysis#consumption_centers_support', as: 'multiple_consumption_support'

		post 'analysis/management_number_two', to: 'multiple_analysis#filter_efficiency_staff', as: 'multiple_filter_efficiency_staff_two'
		get 'analysis/management_number_two', to: 'multiple_analysis#report_number_two', as: 'multiple_report_number_two'

		get 'analysis/detail_report_cost_production_center', to: 'multiple_analysis#report_detail_number_one', as: 'multiple_report_detail_number_one'
		get 'analysis/management_number_one', to: 'multiple_analysis#report_number_one', as: 'multiple_report_number_one'

		post 'analysis/create_range', to: 'multiple_analysis#set_date_ranges', as: 'multiple_set_range_dates'
		get 'analysis/range_dates', to: 'multiple_analysis#date_ranges', as: 'multiple_range_dates'
	end
  #
  scope 'graphics', prefix: 'graphics' do
		#
		get 'analysis_graphs/management_number_one'
		get 'analysis_graphs/detail_report_cost_production_center'
		get 'analysis_graphs/management_number_two'
		post 'analysis_graphs/filter_cost_center'
		get 'analysis_graphs/detail_management_number_two'
		get 'analysis_graphs/consumption_centers_support'
		post 'analysis_graphs/data_consumption'

		# validar para quitar
		get 'analysis_graphs/detail_report_efficiency'
		post 'analysis_graphs/detail_efficiency_find_data'

		get 'analysis_graphs/compare_information'
		post 'analysis_graphs/production_centers_that_support'
		post 'analysis_graphs/compare_information_search'
  end

  # Ajax application requests
  scope 'asynchronous_requests', prefix: 'asynchronous_requests' do
	#
	get 'production_cost_centers/save_production_cost_centers' => 'production_cost_centers#save_production_cost_centers', as: 'save_production_cost_centers'
	#
	get 'cost_centers/next_code' => 'cost_centers#ajax_next_code', as: 'cost_centers_next_code'
	#
	get 'staffs/next_code' => 'staffs#ajax_next_code', as: 'staffs_next_code'
	#
	get 'supplies/next_code' => 'supplies#ajax_next_code', as: 'supplies_next_code'
	#
	get 'entities/search_entities_for_country' => 'entities#get_entity_for_country', as: 'search_entities_for_country'
	#
	get 'networks/search_networks_for_country' => 'networks#get_network_for_country', as: 'search_networks_for_country'
	#
	get 'incomes/save_incomes' => 'incomes#save_incomes', as: 'save_incomes'
	#
	get 'distribution_costs/save_distribution_costs' => 'distribution_costs#save_distribution_costs', as: 'save_distribution_costs'
	#
	get 'distribution_overheads/update_general_values' => 'distribution_overheads#update_general_values', as: 'update_general_values'
	#
	get 'distribution_overheads/update_type_distributions' => 'distribution_overheads#update_type_distributions', as: 'update_type_distributions'
	#
	get 'distribution_overheads/save_distribution_overheads' => 'distribution_overheads#save_distribution_overheads', as: 'save_distribution_overheads'
	#
	get 'distribution_supplies/save_distribution_supplies' => 'distribution_supplies#save_distribution_supplies', as: 'save_distribution_supplies'
	#
	get 'programming_hours/save_programming_hours' => 'programming_hours#save_programming_hours', as: 'save_programming_hours'
	#
	get 'distribution_areas/save_meters' => 'distribution_areas#save_meters', as: 'save_meters_areas'
	#
	get 'entities/belongs_to_location/network' => 'entities#belongs_to_location', as: 'entities_belongs_to_location'
	#
	get 'entities/cost_centers_available' => 'cost_centers#search_available_cost_centers_to_relate', as: 'cost_centers_available_to_relate'
	#
	get 'entities/destroy_associations' => 'entities#destroy_associations', as: 'destroy_entity_association'
	#
	get 'entities/create_associations' => 'entities#create_associations', as: 'create_entity_association'
	# Path that allows to change the date
	get 'change_date' => 'application#change_of_date_for_costs', as: 'change_of_date_for_costs_ajax'
	# Path that allows to change the entity
	get 'entities/change_entity' => 'entities#change_entity', as: 'change_entity_ajax'
	# Path that allows to change the network
	get 'networks/change_network' => 'networks#change_network', as: 'change_network_ajax'
	# Path that allows to change the country
	get 'geographies/change_country' => 'geographies#change_country', as: 'change_country_ajax'
  end

  scope 'cost_tool', prefix: 'cost_tool' do
		# Routes scaffold for Production of Cost Centers
		resources :production_cost_centers do
			collection { post :import }
		end
		# Routes scaffold for Incomes
		resources :incomes
		# Routes scaffold for Distributions Costs per Cost Centers
		resources :distribution_costs, only: [:index] do
		  collection { post :import }
		end
		# Routes scaffold for Distributions Overheads
		resources :distribution_overheads, only: [:index] do
		  collection { post :import }
		end
		# Routes scaffold for Distributions Supplies
		resources :distribution_supplies, only: [:index] do
		  collection { post :import }
		end
		# Routes scaffold for Programming Hours
		resources :programming_hours, only: [:index] do
		  collection { post :import }
		end
		# Routes scaffold for Distribution Areas
		resources :distribution_areas, only: [:index] do
			collection { post :import }
		end
		# Routes scaffold for Payrolls
		resources :payrolls do
			collection { post :import }
			collection { post :validate_dates_for_entity }
		end
  end

  scope 'local_parametrization', prefix: 'local_parametrization' do
	# Routes scaffold for Income Definitions
	resources :income_definitions, except: [:show, :new]
	# Routes scaffold for Salary Components
	resources :salary_components, except: [:show, :destroy]
	# Routes scaffold for Networks
	resources :networks, except: [:show, :destroy]
	# Routes scaffold for Labor Laws
	resources :labor_laws, except: [:show, :destroy] do
		collection { get :standard_configuration }
	end
	# Route for associations models per Entities
	get 'entities/:id/associations' => 'entities#associations', as: 'entity_associations'
	# Routes scaffold for Entities
	resources :entities, except: [:show, :destroy]
  end

  # Parametrization paths for the app.
  scope 'parametrization', prefix: 'parametrization' do
	# Routes scaffold for Cost Centers
	resources :cost_centers, except: [:show, :destroy]
	# Routes scaffold for Staffs
	resources :staffs, except: [:show, :destroy]
	# Routes scaffold for Supplies
	resources :supplies, except: [:show, :destroy]	
	# Routes scaffold for Production Units
	resources :production_units, except: [:show, :destroy]
	# Routes scaffold for Care Levels
	resources :care_levels, except: [:show, :destroy]
	# Routes scaffold for Cost Distributions
	resources :cost_distributions, except: [:show, :destroy]
	# Routes scaffold for Supplies Categories
	resources :supplies_categories, except: [:show, :destroy]
	# Validate unique code
	get 'geographies/validate_unique_code' => 'geographies#validate_unique_code', as: 'validate_geography_unique_code'
	# Create levels of geography
	get 'geographies/create_level/second_level' => 'geographies#create_second_level', as: 'create_geography_second_level'
	get 'geographies/create_level/third_level' => 'geographies#create_third_level', as: 'create_geography_third_level'
	get 'geographies/create_level/fourth_level' => 'geographies#create_fourth_level', as: 'create_geography_fourth_level'
	get 'geographies/create_level/fifth_level' => 'geographies#create_fifth_level', as: 'create_geography_fifth_level'
	# Get levels of Geography
	get 'geographies/third_level' => 'geographies#get_third_level', as: 'get_geographies_third_level'
	get 'geographies/fourth_level' => 'geographies#get_fourth_level', as: 'get_geographies_fourth_level'
	get 'geographies/fifth_level' => 'geographies#get_fifth_level', as: 'get_geographies_fifth_level'
	# Routes scaffold for Geographies
	resources :geographies, except: [:show, :destroy]
	# Configuration paths for the gem Devise.
	devise_for :users, controllers: {
		registrations: 'devise_user/registrations',
		sessions: 'devise_user/sessions',
		passwords: 'devise_user/passwords'
	}
	# Routes scaffold for Users, additional features to devise
	resources :users, only: [:index, :edit, :update]
  end

  # Configuration paths for the app.
  scope 'settings', prefix: 'settings' do
	resources :languages, except: [:show, :destroy]
  end

  # Dynamic URL root for user role.
  root 'application#url_root'
end
