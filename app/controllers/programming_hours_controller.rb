class ProgrammingHoursController < ApplicationController
	before_action :set_programming_hour, only: [:show, :edit, :update, :destroy]

	# GET /programming_hours
	# GET /programming_hours.json
	def index
		@cost_centers = CostCenter.active.for_entity(session[:entity_id]).order_priority.order(:code)
		#@payrolls = Payroll.for_entity(session[:entity_id]).date(session[:year], session[:month])

		#@staffs = ActiveRecord::Base.connection.select_all("CALL get_staff_entity(#{session[:year]}, #{session[:month]}, #{session[:entity_id]}, #{session[:country_id]})").to_hash
		#ActiveRecord::Base.clear_active_connections!

		@staffs = Payroll.joins('INNER JOIN labor_laws ON payrolls.labor_law_id = labor_laws.id
														INNER JOIN staffs ON labor_laws.staff_id = staffs.id
														INNER JOIN labor_standards ON labor_laws.labor_standard_id = labor_standards.id
														INNER JOIN contract_types ON labor_laws.contract_type_id = contract_types.id
														INNER JOIN salary_components ON 1 = 1')
						.where('payrolls.year = ? AND payrolls.month = ? AND payrolls.entity_id = ? AND salary_components.geography_id = ?', session[:year], session[:month], session[:entity_id], session[:country_id])
						.select("payrolls.id, payrolls.salary, CONCAT(payrolls.dni,'-', payrolls.name, ' ', labor_standards.description, '-', staffs.description) AS roster, salary_components.id AS salary_component_id, salary_components.abbreviation, contract_types.description AS contract_type, salary_components.rate, labor_laws.min_wage, salary_components.max_value")
						.order('payrolls.id, salary_components.id')
						.paginate(:page => params[:page], :per_page => 20)

		@programming_hours = ProgrammingHour.date(session[:year], session[:month]).for_entity(session[:entity_id]).where('hours > 0')
		respond_to do |format|
			format.html
			format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{ProgrammingHour.model_name.human}_#{session[:year]}_#{session[:month]}.xls\"" }
			format.xls_empty {
				headers["Content-Disposition"] = "attachment; filename=\"Format_#{ProgrammingHour.model_name.human}_#{session[:year]}_#{session[:month]}.xls\""
			}
		end
	end

	def save_programming_hours
		programming_hour = ProgrammingHour.find_or_initialize_by(year: params[:year], month: params[:month],
																														 entity_id: session[:entity_id], cost_center_id: params[:cost_center],
																														 payroll_id: params[:payroll], salary_component_id: params[:salary_component])
		ProgrammingHour.where(year: params[:year], month: params[:month],
													entity_id: session[:entity_id], payroll_id: params[:payroll]).update_all(paid: params[:paid],
																																																	 total: params[:total])
		programming_hour.year = params[:year]
		programming_hour.month = params[:month]
		programming_hour.entity_id = session[:entity_id]
		programming_hour.cost_center_id = params[:cost_center]
		programming_hour.payroll_id = params[:payroll]
		programming_hour.salary_component_id = params[:salary_component]
		programming_hour.hours = params[:hours]
		programming_hour.total = params[:total]
		programming_hour.paid = params[:paid]
		if not programming_hour.save
			return render :json => programming_hour.errors.to_json, :status => 400
		end
		render :json => 'ok'.to_json, :status => 200
	end

	# POST /payrolls/import
	def import
		if params[:empty_format]
			ProgrammingHour.where(entity_id: session['entity_id'], year: session[:year], month: session[:month]).destroy_all
		end

		ProgrammingHour.import(params[:file], session[:year], session[:month], session[:entity_id])
		
		GenerateReportJob.perform_later(1, session[:year], session[:month], session['entity_id'])

		redirect_to programming_hours_url, notice: "Archivo Importado."
	end

	private
		# Use callbacks to share common setup or constraints between actions.
		def set_programming_hour
			@programming_hour = ProgrammingHour.find(params[:id])
		end

		# Never trust parameters from the scary internet, only allow the white list through.
		def programming_hour_params
			params.require(:programming_hour).permit(:year, :month, :total, :paid, :hours, :entity_id, :cost_center_id, :payroll_id)
		end
end
