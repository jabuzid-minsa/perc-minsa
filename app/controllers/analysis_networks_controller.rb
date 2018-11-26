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
      @entities = Entity.for_users(current_user.id).where(id: filters[:entities]).select('id, code, abbreviation, description')
    end
=begin
    # Headers Direct Costs
    @cost_centers = CostCenter.joins(:entity_cost_centers).where(:entity_cost_centers => { entity_id: filters[:entities] }).order_priority.order(:code).distinct
    @supplies_heads = Supply.joins(:entities).where(:entities_supplies => { entity_id: filters[:entities] } ).where('supplies.supplies_category_id = 1').order(:code).distinct
    @supplies_overheads = Supply.joins(:entities).where(:entities_supplies => { entity_id: filters[:entities] } ).where('supplies.supplies_category_id = 2').order(:code).distinct
    # Direct Costs
    @human_resource = ActiveRecord::Base.connection.select_all("CALL mm_calculate_humanresource(#{commons_parameters}, TRUE)").to_hash
    ActiveRecord::Base.clear_active_connections!
    @supplies = ActiveRecord::Base.connection.select_all("CALL mm_calculate_supplies(#{commons_parameters}, TRUE, FALSE)").to_hash
    ActiveRecord::Base.clear_active_connections!
    @overheads = ActiveRecord::Base.connection.select_all("CALL mm_calculate_overhead(#{commons_parameters}, TRUE, FALSE)").to_hash
    ActiveRecord::Base.clear_active_connections!
    
    # Headers Indirect Costs
    @production_cost_centers = CostCenter.for_entity(filters[:entities]).where.not(function: 3).order_distribution.distinct
    @supported_cost_centers = CostCenter.for_entity(filters[:entities]).order_priority.order(:code).distinct
    # Indirect Costs
    @distribution_processed = ActiveRecord::Base.connection.select_all("CALL mm_calculate_distribution_processed(#{commons_parameters}, FALSE)").to_hash
    ActiveRecord::Base.clear_active_connections!
    @production_centers_data = ActiveRecord::Base.connection.select_all("CALL mm_mul_unit_costs_per_production(#{commons_parameters})").to_hash
    ActiveRecord::Base.clear_active_connections!
=end
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
