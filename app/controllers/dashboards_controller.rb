class DashboardsController < ApplicationController
  def main_dashboard
    if current_user.global_administrator?
      @entities = Entity.available_for_country(Geography.find(session[:country_id]).numerical_code)
    else
      @entities = current_user.entities
    end
  end

  def get_basic_info_entity
    parameters = params_procedures

    entity = Entity.select(:id, :description).find(params[:dashboards][:entity_id])
    human_resource = ActiveRecord::Base.connection.select_all("CALL hs_calc_human_resource(#{parameters},1)").to_hash
    ActiveRecord::Base.clear_active_connections!
    overheads = ActiveRecord::Base.connection.select_all("CALL hs_calc_overheads(#{parameters},1)").to_hash
    ActiveRecord::Base.clear_active_connections!
    supplies = ActiveRecord::Base.connection.select_all("CALL hs_calc_supplies(#{parameters},1)").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: { entity: entity, human_resource: human_resource, overheads: overheads, supplies: supplies }
  end

  def get_cost_per_function_services
    parameters = params_procedures

    costs = ActiveRecord::Base.connection.select_all("CALL hs_cost_per_function_services(#{parameters})").to_hash
    ActiveRecord::Base.clear_active_connections!
    cost_centers = Entity.find(params[:dashboards][:entity_id]).cost_centers.order_priority.order(:code).select(:id, :code, :description, :function)

    render json: { costs: costs, cost_centers: cost_centers }
  end

  def get_info_cost_center
    range_start = params[:dashboards][:date_start].split('/')
    range_end = params[:dashboards][:date_end].split('/')

    costs = ActiveRecord::Base.connection.select_all("CALL hs_info_entity_cost_center(#{range_start[1]},#{range_end[1]},#{range_start[0]},#{range_end[0]},#{params[:dashboards][:cost_center_id]},#{params[:dashboards][:entity_id]})").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: costs
  end

  private
    def params_procedures
      range_start = params[:dashboards][:date_start].split('/')
      range_end = params[:dashboards][:date_end].split('/')

      "#{range_start[1]},#{range_end[1]},#{range_start[0]},#{range_end[0]},#{params[:dashboards][:entity_id]}"
    end
end
