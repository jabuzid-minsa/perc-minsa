class AnalysisGraphsController < ApplicationController

  def management_number_one
    @cost_centers = CostCenter.joins(:entity_cost_centers)
                        .where(:entity_cost_centers => { entity_id: session[:entity_id] }).order_priority.order(:code)

    @human_resource = ActiveRecord::Base.connection.select_all("CALL calculation_human_resource(#{session[:year]},#{session[:month]}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!
    
    @overheads = ActiveRecord::Base.connection.select_all("CALL detail_report_overheads(#{session[:year]},#{session[:month]}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!

    @supplies = ActiveRecord::Base.connection.select_all("CALL detail_report_supplies(#{session[:year]},#{session[:month]}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!

    @distribution_costs = DistributionCost.group(:cost_center_id).select('cost_center_id, sum(value) as value')

    @production_cost_centers = CostCenter.joins(:production_cost_centers)
                                   .where(:production_cost_centers => { year: session[:year], month: session[:month], entity_id: session[:entity_id] })
                                   .select('cost_centers.id, cost_centers.description').distinct

    @distribution_processed = ActiveRecord::Base.connection.select_all("CALL distribution_costs_processed(#{session[:year]},#{session[:month]}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!

    @medicines = DistributionSupply.where(year: session[:year], month: session[:month], entity_id: session[:entity_id], supply_id: 30).select('ROUND(SUM(value),0) AS total')

    @osteosinthesis_material = DistributionSupply.where(year: session[:year], month: session[:month], entity_id: session[:entity_id], supply_id: 16).select('ROUND(SUM(value),0) AS total')

    @total_beds = ProductionCostCenter.joins('INNER JOIN entity_cost_centers ON entity_cost_centers.entity_id = production_cost_centers.entity_id AND entity_cost_centers.cost_center_id = production_cost_centers.cost_center_id').where(year: session[:year], month: session[:month], entity_id: session[:entity_id], production_units: 6).select('ROUND(SUM(value),0) AS total')

    @support_themselves = ActiveRecord::Base.connection.select_all("CALL validate_support_themselves(#{session[:year]},#{session[:month]}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!
  end

  def management_number_two
    @cost_centers = CostCenter.joins(:entity_cost_centers).where(:entity_cost_centers => { entity_id: session[:entity_id] }).order_priority
    @staffs = Staff.for_entity(session[:entity_id])
  end

  def filter_cost_center
    filters = params.require(:filter_cost_center).permit(:cost_center_id)
    cost_center = CostCenter.find(filters[:cost_center_id])
    type_result = cost_center.function == 'final' ? 1 : 2

    production = ActiveRecord::Base.connection.select_all("CALL efficiency_production(#{session[:year]},#{session[:month]},#{session[:entity_id]},#{cost_center.id},#{type_result})").to_hash
    ActiveRecord::Base.clear_active_connections!

    hours = ActiveRecord::Base.connection.select_all("CALL efficiency_hours(#{session[:year]},#{session[:month]},#{session[:entity_id]},#{cost_center.id})").to_hash
    ActiveRecord::Base.clear_active_connections!

    respond_to do |format|
      format.json { render json: {hours: hours, production: production} }
    end
  end

  def detail_management_number_two
    @cost_centers = CostCenter.joins(:entity_cost_centers).where(:entity_cost_centers => { entity_id: session[:entity_id] }).order_priority
    @staffs = Staff.for_entity(session[:entity_id])

    @productions = ActiveRecord::Base.connection.select_all("CALL efficiency_production(#{session[:year]},#{session[:month]},#{session[:entity_id]},0,3)").to_hash
    ActiveRecord::Base.clear_active_connections!

    @hours = ActiveRecord::Base.connection.select_all("CALL efficiency_hours(#{session[:year]},#{session[:month]},#{session[:entity_id]},0)").to_hash
    ActiveRecord::Base.clear_active_connections!
  end

  def consumption_centers_support
    @cost_centers = CostCenter.joins(:entity_cost_centers).where(:entity_cost_centers => { entity_id: session[:entity_id] }).order_priority
    @support_centers = CostCenter.for_entity(session[:entity_id] ).supports.order_priority
  end

  def data_consumption
    filters = params.require(:filter_cost_center).permit(:cost_center_id)
    cost_center = CostCenter.find(filters[:cost_center_id])
    type_result = cost_center.function == 'final' ? 1 : 2

    production = ActiveRecord::Base.connection.select_all("CALL efficiency_production(#{session[:year]},#{session[:month]},#{session[:entity_id]},#{cost_center.id},#{type_result})").to_hash
    ActiveRecord::Base.clear_active_connections!

    support = ActiveRecord::Base.connection.select_all("CALL efficiency_support_consumption(#{session[:year]},#{session[:month]},#{session[:entity_id]},#{cost_center.id})").to_hash
    ActiveRecord::Base.clear_active_connections!

    respond_to do |format|
      format.json { render json: {supports: support, production: production} }
    end
  end

  def production_centers_that_support
    filters = params.require(:production_centers_support).permit(:cost_center_id)
    
    cost_centers = ActiveRecord::Base.connection.select_all("CALL cost_centers_for_entity(#{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!
    main_cost_center = ActiveRecord::Base.connection.select_all("CALL report_efficiency_maincc(#{session[:year]},#{session[:month]}, #{session[:entity_id]}, #{filters[:cost_center_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!
    support_cost_centers = ActiveRecord::Base.connection.select_all("CALL report_efficiency_supportscc(#{session[:year]},#{session[:month]}, #{session[:entity_id]}, #{filters[:cost_center_id]}, 1)").to_hash
    ActiveRecord::Base.clear_active_connections!

    respond_to do |format|
      format.json { render :json => {cost_centers: cost_centers, main_cost_center: main_cost_center, support_cost_centers: support_cost_centers} }
    end
  end

  def detail_report_cost_production_center
    @cost_centers = CostCenter.joins(:entity_cost_centers).where(:entity_cost_centers => { entity_id: session[:entity_id] } ).order_priority.order(:code)
    @staffs = Staff.joins(:entities).where(:entities_staffs => { entity_id: session[:entity_id] } )
    @supplies = Supply.joins(:entities).where(:entities_supplies => { entity_id: session[:entity_id] } ).where('supplies.code LIKE ?', '002%')
    @supplies_overheads = Supply.joins(:entities).where(:entities_supplies => { entity_id: session[:entity_id] } ).where('supplies.supplies_category_id = ?', '2')
    @human_resource = ActiveRecord::Base.connection.select_all("CALL detail_report_human_resources(#{session[:year]},#{session[:month]}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!
    @overheads = ActiveRecord::Base.connection.select_all("CALL detail_report_overheads(#{session[:year]},#{session[:month]}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!
    @data_supplies = ActiveRecord::Base.connection.select_all("CALL detail_report_supplies(#{session[:year]},#{session[:month]}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!
    # Indirect Costs
    @production_cost_centers = CostCenter.for_entity(session[:entity_id]).where.not(function: 3).order_distribution
    @supported_cost_centers = CostCenter.for_entity(session[:entity_id]).order_priority.order(:code)
    
    @distribution_processed = ActiveRecord::Base.connection.select_all("CALL distribution_costs_processed(#{session[:year]},#{session[:month]}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!

    @production_centers_data = ActiveRecord::Base.connection.select_all("CALL unit_costs_per_production(#{session[:year]},#{session[:month]}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!
  end

  def detail_report_efficiency

  end

  def detail_efficiency_find_data
    filters = params.require(:filter_data).permit(:production_unit)
    cost_centers = ActiveRecord::Base.connection.select_all("CALL detail_report_eficc(#{session[:entity_id]}, #{filters[:production_unit]})").to_hash
    ActiveRecord::Base.clear_active_connections!

    total_data = ActiveRecord::Base.connection.select_all("CALL detail_report_main_cc(#{session[:year]},#{session[:month]}, #{session[:entity_id]}, #{filters[:production_unit]})").to_hash
    ActiveRecord::Base.clear_active_connections!

    distribution_costs = DistributionCost.date(session[:year], session[:month]).for_entity(session[:entity_id])
                             .where(production_units: filters[:production_unit])
                             .select('distribution_costs.cost_center_id, distribution_costs.supported_cost_center_id, distribution_costs.value')

    respond_to do |format|
      format.json { render :json => {cost_centers: cost_centers, total_data: total_data, distribution_costs: distribution_costs } }
    end
  end

  def compare_information
    @cost_centers = CostCenter.joins(:entity_cost_centers).where(:entity_cost_centers => { entity_id: session[:entity_id] } ).order_priority.order(:code)
  end

  def compare_information_search
    filters = params.require(:comparative_filters).permit(:comparative_date, :cost_center_id)

    current_hr = ActiveRecord::Base.connection.select_all("CALL calculation_human_resource(#{session[:year]},#{session[:month]}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!
    current_ov = ActiveRecord::Base.connection.select_all("CALL detail_report_overheads(#{session[:year]},#{session[:month]}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!
    current_sp = ActiveRecord::Base.connection.select_all("CALL detail_report_supplies(#{session[:year]},#{session[:month]}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!

    comparative_hr = ActiveRecord::Base.connection.select_all("CALL calculation_human_resource(#{filters[:comparative_date].split("-").last},#{filters[:comparative_date].split("-").first}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!
    comparative_ov = ActiveRecord::Base.connection.select_all("CALL detail_report_overheads(#{filters[:comparative_date].split("-").last},#{filters[:comparative_date].split("-").first}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!
    comparative_sp = ActiveRecord::Base.connection.select_all("CALL detail_report_supplies(#{filters[:comparative_date].split("-").last},#{filters[:comparative_date].split("-").first}, #{session[:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!

    data = {
        current_date: {
          human_resource: current_hr,          
          overheads: current_ov,
          supplies: current_sp
        },
        comparative: {
          human_resource: comparative_hr,
          overheads: comparative_ov,
          supplies: comparative_sp
        }
      }

    respond_to do |format|
      format.json { render :json => data }
    end
  end
end
