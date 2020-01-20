class MultipleAnalysisController < ApplicationController
  before_action :validate_session_date_range, except: [:date_ranges, :set_date_ranges]
  before_action :set_entity, only: [:report_number_one, :report_detail_number_one, :report_number_two, :consumption_centers_support, :performance_beeds]

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

  ### Production, Costs and Efficiency
  def report_number_one        
    end_date = Date.civil((session[:date_end].split('/')[1]).to_i, (session[:date_end].split('/')[0]).to_i, -1)        
    star_date = Date.strptime("#{session[:date_start].split('/')[1]}-#{session[:date_start].split('/')[0]}-01", '%Y-%m-%d')
    months = ((end_date.month - star_date.month) + 12 * (end_date.year - star_date.year))
    @cost_centers = CostCenter.joins(:entity_cost_centers).where(:entity_cost_centers => { entity_id: session[:entity_id] }).order_priority.order(:code)
    @months_total = months
    @starting_date = Date.strptime("#{session[:date_start].split('/')[1]}-#{session[:date_start].split('/')[0]}", '%Y-%m')
    @final_date = Date.strptime("#{session[:date_end].split('/')[1]}-#{session[:date_end].split('/')[0]}", '%Y-%m')

    @income = Income.where(entity_id: session[:entity_id])
                    .where("CAST(CONCAT(year, '-', month, '-1') AS DATE) BETWEEN CAST('#{star_date}' AS DATE) AND CAST('#{end_date}' AS DATE)")
                    .sum(:value)
  end

  ### Production, Costs and Efficiency
  # First Panel: Control Panel
  def rno_control_panel
    settings = "#{session[:date_start].split('/')[1]},#{session[:date_end].split('/')[1]},#{session[:date_start].split('/')[0]},#{session[:date_end].split('/')[0]},'#{session[:entity_id]}'"
    
    human_resource = ActiveRecord::Base.connection.select_all("CALL hs_calc_human_resource(#{settings},1)").to_hash
    ActiveRecord::Base.clear_active_connections!

    overheads = ActiveRecord::Base.connection.select_all("CALL hs_calc_overheads(#{settings},1)").to_hash
    ActiveRecord::Base.clear_active_connections!

    supplies = ActiveRecord::Base.connection.select_all("CALL hs_calc_supplies(#{settings},1)").to_hash
    ActiveRecord::Base.clear_active_connections!
    
    specialvalues = ActiveRecord::Base.connection.select_all("CALL hs_calc_specialvalues(#{settings})").to_hash
    ActiveRecord::Base.clear_active_connections!

    parent_groups = ActiveRecord::Base.connection.select_all("CALL hs_calc_parent_groups(#{settings})").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: { hs: human_resource, ov: overheads, sp: supplies, spv: specialvalues, pg: parent_groups }, status: :ok
  end

  ### Production, Costs and Efficiency
  # Second Panel: Cost Total per month
  def total_per_month
    settings = "#{session[:date_start].split('/')[1]},#{session[:date_end].split('/')[1]},#{session[:date_start].split('/')[0]},#{session[:date_end].split('/')[0]},'#{session[:entity_id]}'"

    human_resource = ActiveRecord::Base.connection.select_all("CALL hs_calc_human_resource(#{settings},0)").to_hash
    ActiveRecord::Base.clear_active_connections!

    overheads = ActiveRecord::Base.connection.select_all("CALL hs_calc_overheads(#{settings},0)").to_hash
    ActiveRecord::Base.clear_active_connections!

    supplies = ActiveRecord::Base.connection.select_all("CALL hs_calc_supplies(#{settings},0)").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: { hs: human_resource, ov: overheads, sp: supplies }, status: :ok
  end

  ### Production, Costs and Efficiency
  # Fourth Panel: Cost Total per month
  def total_per_cost_center
    settings = "#{session[:date_start].split('/')[1]},#{session[:date_end].split('/')[1]},#{session[:date_start].split('/')[0]},#{session[:date_end].split('/')[0]},'#{session[:entity_id]}'"

    human_resource = ActiveRecord::Base.connection.select_all("CALL hs_calc_human_resource(#{settings},2)").to_hash
    ActiveRecord::Base.clear_active_connections!

    overheads = ActiveRecord::Base.connection.select_all("CALL hs_calc_overheads(#{settings},2)").to_hash
    ActiveRecord::Base.clear_active_connections!

    supplies = ActiveRecord::Base.connection.select_all("CALL hs_calc_supplies(#{settings},2)").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: { hs: human_resource, ov: overheads, sp: supplies }, status: :ok
  end

  ### Production, Costs and Efficiency
  # Six Panel: Cost Indirects
  def total_indirects
    settings = "#{session[:date_start].split('/')[1]},#{session[:date_end].split('/')[1]},#{session[:date_start].split('/')[0]},#{session[:date_end].split('/')[0]},'#{session[:entity_id]}'"

    indirec_costs = ActiveRecord::Base.connection.select_all("CALL hs_calc_indirect_costs(#{settings},0)").to_hash
    ActiveRecord::Base.clear_active_connections!

    remnants = ActiveRecord::Base.connection.select_all("CALL hs_calc_indirect_remnants(#{settings})").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: { indirect: indirec_costs, remnants: remnants }, status: :ok
  end

  ### Table 4
  def report_detail_number_one
    settings = session[:entity_id] + ',' + session[:date_start].split('/')[1] + ',' + session[:date_start].split('/')[0] + ',' + session[:date_end].split('/')[1] + ',' + session[:date_end].split('/')[0]

    @cost_centers = CostCenter.joins(:entity_cost_centers).where(:entity_cost_centers => { entity_id: session[:entity_id] }).order_priority.order(:code)
    @supplies = Supply.joins(:entities).where(:entities_supplies => { entity_id: session[:entity_id] } ).where('supplies.supplies_category_id = ?', '1').order(:code)
    @overheads = Supply.joins(:entities).where(:entities_supplies => { entity_id: session[:entity_id] } ).where('supplies.supplies_category_id = ?', '2').order(:code)
    # Indirect Costs
    @production_cost_centers = CostCenter.for_entity(session[:entity_id]).where.not(function: 3).order_distribution
  end

  ### Table 4
  # First Panel: Direct Costs
  def tf_direct_costs
    settings = "#{session[:date_start].split('/')[1]},#{session[:date_end].split('/')[1]},#{session[:date_start].split('/')[0]},#{session[:date_end].split('/')[0]},'#{session[:entity_id]}'"

    human_resource = ActiveRecord::Base.connection.select_all("CALL hs_calc_human_resource(#{settings},3)").to_hash
    ActiveRecord::Base.clear_active_connections!

    overheads = ActiveRecord::Base.connection.select_all("CALL hs_calc_overheads(#{settings},3)").to_hash
    ActiveRecord::Base.clear_active_connections!

    supplies = ActiveRecord::Base.connection.select_all("CALL hs_calc_supplies(#{settings},3)").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: { hs: human_resource, ov: overheads, sp: supplies }, status: :ok
  end

  ### Table 4
  # Second Panel: Indirect Costs
  def tf_indirect_costs
    settings = "#{session[:date_start].split('/')[1]},#{session[:date_end].split('/')[1]},#{session[:date_start].split('/')[0]},#{session[:date_end].split('/')[0]},'#{session[:entity_id]}'"

    indirec_costs = ActiveRecord::Base.connection.select_all("CALL hs_calc_indirect_costs(#{settings},3)").to_hash
    ActiveRecord::Base.clear_active_connections!

    remnants = ActiveRecord::Base.connection.select_all("CALL hs_calc_indirect_remnants(#{settings})").to_hash
    ActiveRecord::Base.clear_active_connections!

    total_indirects = ActiveRecord::Base.connection.select_all("CALL hs_calc_indirect_costs(#{settings},2)").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: { indirect: indirec_costs, remnants: remnants, totals: total_indirects }, status: :ok
  end

  ### Table 4
  # Second Panel: Indirect Costs
  def tf_production_info
    settings = "#{session[:date_start].split('/')[1]},#{session[:date_end].split('/')[1]},#{session[:date_start].split('/')[0]},#{session[:date_end].split('/')[0]},'#{session[:entity_id]}'"

    production = ActiveRecord::Base.connection.select_all("CALL hs_calc_production_unit(#{settings})").to_hash

    render json: { production: production }, status: :ok
  end

  ### Other's
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

  def performance_beeds
    @cost_centers = @entity.cost_centers.have_beeds.order_priority.order(:code).select(:id, :code, :description, :function)
  end

  def total_cost_performance_beeds
    settings = "#{session[:date_start].split('/')[1]},#{session[:date_end].split('/')[1]},#{session[:date_start].split('/')[0]},#{session[:date_end].split('/')[0]},'#{session[:entity_id]}'"

    costs = ActiveRecord::Base.connection.select_all("CALL hscalc_total_centers(#{settings})").to_hash
    ActiveRecord::Base.clear_active_connections!

    production = ActiveRecord::Base.connection.select_all("CALL hs_calc_production_unit(#{settings})").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: { costs: costs, production: production }
  end

  private
    #
    def validate_session_date_range
      unless session[:date_start].present? && session[:date_end].present?
        redirect_to multiple_range_dates_url
      end
    end

    #
    def set_entity
      @entity = Entity.find(session[:entity_id])
    end
end
