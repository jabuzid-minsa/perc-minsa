class MultipleAnalysisController < ApplicationController
	before_action :validate_session_date_range, except: [:date_ranges, :set_date_ranges]

	def date_ranges
	end

	def set_date_ranges
		unless params[:date][:start].present? || params[:date][:end].present?
			redirect_to :back, alert: 'Debe seleccionar fecha inicial y final.'
		end

		session[:date_start] = params[:date][:start]
		session[:date_end] = params[:date][:end]

		redirect_to multiple_report_number_one_url
	end

	def report_number_one
		settings = session[:entity_id] + ',' + session[:date_start].split('/')[1] + ',' + session[:date_start].split('/')[0] + ',' + session[:date_end].split('/')[1] + ',' + session[:date_end].split('/')[0]
		end_date = Date.civil((session[:date_end].split('/')[1]).to_i, (session[:date_end].split('/')[0]).to_i, -1)
		#months = (end_date - Date.strptime("#{session[:date_start].split('/')[1]}-#{session[:date_start].split('/')[0]}-01", '%Y-%m-%d')).to_f
		star_date = Date.strptime("#{session[:date_start].split('/')[1]}-#{session[:date_start].split('/')[0]}-01", '%Y-%m-%d')
		months = ((end_date.month - star_date.month) + 12 * (end_date.year - star_date.year))

		@cost_centers = CostCenter.joins(:entity_cost_centers).where(:entity_cost_centers => { entity_id: session[:entity_id] }).order_priority.order(:code)

		@human_resource = ActiveRecord::Base.connection.select_all("CALL calculate_humanresource(#{settings},FALSE)").to_hash
		ActiveRecord::Base.clear_active_connections!

		@overheads = ActiveRecord::Base.connection.select_all("CALL calculate_overhead(#{settings},FALSE,TRUE)").to_hash
		ActiveRecord::Base.clear_active_connections!

		@supplies = ActiveRecord::Base.connection.select_all("CALL calculate_supplies(#{settings},FALSE,TRUE)").to_hash
		ActiveRecord::Base.clear_active_connections!

		@distribution_processed = ActiveRecord::Base.connection.select_all("CALL calculate_distribution_processed(#{settings},FALSE)").to_hash
		ActiveRecord::Base.clear_active_connections!

		@total_selfsupport = DistributionCost.where(year: session[:date_start].split('/')[1]..session[:date_end].split('/')[1], month: session[:date_start].split('/')[0]..session[:date_end].split('/')[0], entity_id: session[:entity_id]).where('distribution_costs.cost_center_id = distribution_costs.supported_cost_center_id AND distribution_costs.value > 0').select('DISTINCT cost_center_id').count

		@selfsupport = ActiveRecord::Base.connection.select_all("CALL calculate_selfsupport(#{settings})").to_hash
		ActiveRecord::Base.clear_active_connections!

		@medicines = DistributionSupply.where(year: session[:date_start].split('/')[1]..session[:date_end].split('/')[1], month: session[:date_start].split('/')[0]..session[:date_end].split('/')[0], entity_id: session[:entity_id], supply_id: 30).select('ROUND(SUM(value),0) AS total')

		@osteosinthesis_material = DistributionSupply.where(year: session[:date_start].split('/')[1]..session[:date_end].split('/')[1], month: session[:date_start].split('/')[0]..session[:date_end].split('/')[0], entity_id: session[:entity_id], supply_id: 16).select('ROUND(SUM(value),0) AS total')

		beds = ActiveRecord::Base.connection.select_all("CALL calculate_beds(#{settings})").to_hash
		ActiveRecord::Base.clear_active_connections!

		@total_beds = beds[0]['value']
		
		#@months_total = (months.abs/30).to_i - 1
		@months_total = months

		@starting_date = Date.strptime("#{session[:date_start].split('/')[1]}-#{session[:date_start].split('/')[0]}", '%Y-%m')
		@final_date = Date.strptime("#{session[:date_end].split('/')[1]}-#{session[:date_end].split('/')[0]}", '%Y-%m')
	end

	def report_detail_number_one
		settings = session[:entity_id] + ',' + session[:date_start].split('/')[1] + ',' + session[:date_start].split('/')[0] + ',' + session[:date_end].split('/')[1] + ',' + session[:date_end].split('/')[0]

		@cost_centers = CostCenter.joins(:entity_cost_centers).where(:entity_cost_centers => { entity_id: session[:entity_id] }).order_priority.order(:code)
		@supplies_heads = Supply.joins(:entities).where(:entities_supplies => { entity_id: session[:entity_id] } ).where('supplies.supplies_category_id = ?', '1')
    @supplies_overheads = Supply.joins(:entities).where(:entities_supplies => { entity_id: session[:entity_id] } ).where('supplies.supplies_category_id = ?', '2')

		@human_resource = ActiveRecord::Base.connection.select_all("CALL calculate_humanresource(#{settings},TRUE)").to_hash
    ActiveRecord::Base.clear_active_connections!

    @overheads = ActiveRecord::Base.connection.select_all("CALL calculate_overhead(#{settings},TRUE,FALSE)").to_hash
    ActiveRecord::Base.clear_active_connections!

    @supplies = ActiveRecord::Base.connection.select_all("CALL calculate_supplies(#{settings},TRUE,FALSE)").to_hash
    ActiveRecord::Base.clear_active_connections!

    # Indirect Costs
    @production_cost_centers = CostCenter.for_entity(session[:entity_id]).where.not(function: 3).order_distribution
    
    @supported_cost_centers = CostCenter.for_entity(session[:entity_id]).order_priority.order(:code)
    
    @distribution_processed = ActiveRecord::Base.connection.select_all("CALL calculate_distribution_processed(#{settings},FALSE)").to_hash
    ActiveRecord::Base.clear_active_connections!

    @production_centers_data = ActiveRecord::Base.connection.select_all("CALL mul_unit_costs_per_production(#{settings})").to_hash
    ActiveRecord::Base.clear_active_connections!
	end

	def report_number_two
		@cost_centers = CostCenter.joins(:entity_cost_centers).where(:entity_cost_centers => { entity_id: session[:entity_id] }).order_priority
    @staffs = Staff.for_entity(session[:entity_id])
	end

	def filter_efficiency_staff
		settings = session[:entity_id] + ',' + session[:date_start].split('/')[1] + ',' + session[:date_start].split('/')[0] + ',' + session[:date_end].split('/')[1] + ',' + session[:date_end].split('/')[0]
		filters = params.require(:filter_cost_center).permit(:cost_center_id)
    cost_center = CostCenter.find(filters[:cost_center_id])
    type_result = cost_center.function == 'final' ? 1 : 2

    production = ActiveRecord::Base.connection.select_all("CALL calculate_effi_production(#{settings},#{cost_center.id},#{type_result})").to_hash
    ActiveRecord::Base.clear_active_connections!

    hours = ActiveRecord::Base.connection.select_all("CALL calculate_efficiency_hours(#{settings},#{cost_center.id})").to_hash
    ActiveRecord::Base.clear_active_connections!

    respond_to do |format|
      format.json { render json: {hours: hours, production: production} }
    end
	end

	def consumption_centers_support
		@cost_centers = CostCenter.joins(:entity_cost_centers).where(:entity_cost_centers => { entity_id: session[:entity_id] }).order_priority
    @support_centers = CostCenter.for_entity(session[:entity_id] ).supports.order_priority
	end

	def data_consumption
		settings = session[:entity_id] + ',' + session[:date_start].split('/')[1] + ',' + session[:date_start].split('/')[0] + ',' + session[:date_end].split('/')[1] + ',' + session[:date_end].split('/')[0]
    filters = params.require(:filter_cost_center).permit(:cost_center_id)
    cost_center = CostCenter.find(filters[:cost_center_id])
    type_result = cost_center.function == 'final' ? 1 : 2

    production = ActiveRecord::Base.connection.select_all("CALL calculate_effi_production(#{settings},#{cost_center.id},#{type_result})").to_hash
    ActiveRecord::Base.clear_active_connections!

    support = ActiveRecord::Base.connection.select_all("CALL calculate_support_consumption(#{settings},#{cost_center.id})").to_hash
    ActiveRecord::Base.clear_active_connections!

    respond_to do |format|
      format.json { render json: {supports: support, production: production} }
    end
  end

	private

		def validate_session_date_range
			unless session[:date_start].present? && session[:date_end].present?
				redirect_to multiple_range_dates_url
			end
		end

end
