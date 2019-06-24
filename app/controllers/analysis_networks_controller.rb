class AnalysisNetworksController < ApplicationController
  authorize_resource :class => false

  # GET /filter_entities
  def filter_analysis
    if current_user.is_global_administrator?
      geographies = Geography.joins(:entities).uniq.pluck(:numerical_code)
      @countries = Geography.where(numerical_code: geographies).countries
      @networks = Network.active
      @entities = Entity.active
    else
      @countries = [current_user.geography]
      @networks = Network.for_users(current_user.id)
      @entities = Entity.for_users(current_user.id)
    end
  end

  # GET /filter_entities/country => only AJAX
  def filter_entities_country
    if current_user.is_global_administrator?
      if params[:country].present?
        entities = Entity.joins(:geography).where(geographies: { numerical_code: params[:country] })
        networks = Network.joins(:geography).where(geographies: { numerical_code: params[:country] })
      else
        entities = Entity.active
        networks = Network.active
      end
    else
      if params[:country].present?
        networks = Network.joins(:geography).for_users(current_user.id).active.where(geographies: { numerical_code: params[:country] })
        entities = Entity.joins(:geography).for_users(current_user.id).active.where(geographies: { numerical_code: params[:country] })
      else
        networks = Network.for_users(current_user.id).active
        entities = Entity.for_users(current_user.id).active
      end
    end

    render json: { entities: entities, networks: networks }, status: :ok
  end

  # GET /filter_entities/network => only AJAX
  def filter_entities_network
    if current_user.is_global_administrator?
      if params[:network].present?
        entities = Entity.joins(:networks).where(networks: { id: params[:network] })
      else
        if params[:country].present?
          entities = Entity.joins(:geography).where(geographies: { numerical_code: params[:country] })
        else
          entities = Entity.active
        end
      end
    else
      if params[:network].present?
        entities = Entity.joins(:networks).for_users(current_user.id).where(networks: { id: params[:network] })
      else
        entities = Entity.joins(:networks).for_users(current_user.id)
      end
    end

    render json: entities, status: :ok
  end

  # POST /filter_entities
  def analysis_entities
    filters = analysis_entities_params()
    @date_parameters = "#{filters[:start_year]}_#{filters[:final_year]}_#{filters[:start_month]}_#{filters[:final_month]}"
    @entities_parameters = "#{filters[:string_entities]}"

    if current_user.global_administrator?
      @entities = Entity.where(id: filters[:entities]).select('id, code, abbreviation, description')
    else
      @entities = Entity.for_users(current_user.id).where(id: filters[:entities]).select('entities.id, entities.code, entities.abbreviation, entities.description')
    end
  end

  # /network/human_resource
  def get_human_resource
    dates = params[:dates].gsub! '_', ','
    human_resource = ActiveRecord::Base.connection.select_all("CALL hs_calc_human_resource(#{dates},'#{params[:entities]}',4)").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: human_resource, status: :ok
  end

  # /network/overheads
  def get_overheads
    dates = params[:dates].gsub! '_', ','
    overheads = ActiveRecord::Base.connection.select_all("CALL hs_calc_overheads(#{dates},'#{params[:entities]}',4)").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: overheads, status: :ok
  end

  # /network/supplies
  def get_supplies
    dates = params[:dates].gsub! '_', ','
    supplies = ActiveRecord::Base.connection.select_all("CALL hs_calc_supplies(#{dates},'#{params[:entities]}',4)").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: supplies, status: :ok
  end

  # /network/special_values
  def get_special_values
    dates = params[:dates].gsub! '_', ','
    special = ActiveRecord::Base.connection.select_all("CALL hs_calc_specialvalues(#{dates},'#{params[:entities]}')").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: special, status: :ok
  end

  # /network/parent_values
  def get_parents_values
    dates = params[:dates].gsub! '_', ','
    parents = ActiveRecord::Base.connection.select_all("CALL hscalc_direct_total_gparent(#{dates},'#{params[:entities]}')").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: parents, status: :ok
  end

  # /network/cost_centers
  def get_cost_centers
    cost_centers = CostCenter.joins(:entity_cost_centers).where(entity_cost_centers: { entity_id: params[:entities].split(",") })
                              .select('cost_centers.id, cost_centers.code, cost_centers.description').order_priority.order(:code).distinct

    overheads = Supply.joins(:entities).where(supplies_category_id: 2).where(entities: { id: params[:entities].split(",") })
                              .select('supplies.id, supplies.code, supplies.description').order(:code).distinct

    supplies = Supply.joins(:entities).where(supplies_category_id: 1).where(entities: { id: params[:entities].split(",") })
                              .select('supplies.id, supplies.code, supplies.description').order(:code).distinct

    render json: { cost_centers: cost_centers, overheads: overheads, supplies: supplies }, status: :ok
  end

  # /network/costs_per_production_center
  # def get_costs_per_production_center
  #   dates = params[:dates].gsub! '_', ','
  #   hs = ActiveRecord::Base.connection.select_all("CALL hs_calc_human_resource(#{dates},'#{params[:entities]}',3)").to_hash
  #   ActiveRecord::Base.clear_active_connections!

  #   ov = ActiveRecord::Base.connection.select_all("CALL hs_calc_overheads(#{dates},'#{params[:entities]}',3)").to_hash
  #   ActiveRecord::Base.clear_active_connections!

  #   sp = ActiveRecord::Base.connection.select_all("CALL hs_calc_supplies(#{dates},'#{params[:entities]}',3)").to_hash
  #   ActiveRecord::Base.clear_active_connections!

  #   render json: { human_resource: hs, overheads: ov, supplies: sp }, status: :ok
  # end

  # /network/support_cost_centers
  def get_support_cost_centers
    cost_centers = CostCenter.joins(:entity_cost_centers).where.not(function: 3).where(entity_cost_centers: { entity_id: params[:entities].split(",") })
                              .select('cost_centers.id, cost_centers.code, cost_centers.description').order_distribution.distinct

    render json: cost_centers, status: :ok
  end

  # /network/remaining_costs
  def get_remaining_costs
    dates = params[:dates].gsub! '_', ','
    cost_centers = CostCenter.joins(:entity_cost_centers).where(function: 3).where(entity_cost_centers: { entity_id: params[:entities].split(",") })
                              .select('cost_centers.id, cost_centers.code, cost_centers.description').order(:code).distinct

    remnant = ActiveRecord::Base.connection.select_all("CALL hs_calc_indirect_remnants(#{dates},'#{params[:entities]}')").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: { cost_centers: cost_centers, remnant: remnant }, status: :ok
  end

  # /network/indirect_costs
  def get_indirect_costs
    dates = params[:dates].gsub! '_', ','
    indirect_costs = ActiveRecord::Base.connection.select_all("CALL hs_calc_indirect_costs(#{dates},'#{params[:entities]}',3)").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: indirect_costs, status: :ok
  end

  # /network/production_unit
  def get_production_unit
    dates = params[:dates].gsub! '_', ','
    total_centers = ActiveRecord::Base.connection.select_all("CALL hscalc_total_centers(#{dates},'#{params[:entities]}')").to_hash
    ActiveRecord::Base.clear_active_connections!
    production_unit = ActiveRecord::Base.connection.select_all("CALL hs_calc_production_unit(#{dates},'#{params[:entities]}')").to_hash
    ActiveRecord::Base.clear_active_connections!

    render json: { production: production_unit, totals: total_centers}, status: :ok
  end

  private
    def analysis_entities_params
      filters = params.require(:analysis_networks).permit(:date_start, :date_end, :entities => [])

      final_filters = {
        entities: filters[:entities],
        start_year: filters[:date_start].split('/')[1],
        start_month: filters[:date_start].split('/')[0],
        final_year: filters[:date_end].split('/')[1],
        final_month: filters[:date_end].split('/')[0],
        string_entities: filters[:entities].join(',')
      }
    end
end
