class DistributionCostsController < ApplicationController
  before_action :set_distribution_cost, only: [:show, :edit, :update, :destroy]

  # GET /distribution_costs
  # GET /distribution_costs.json
  def index
    @cost_centers = CostCenter.for_entity(session[:entity_id]).supports.order_priority.order(:code)
    @supported_cost_centers = CostCenter.for_entity(session[:entity_id]).order_priority.order(:code)
    @distribution_costs = DistributionCost.date(session[:year], session[:month]).for_entity(session[:entity_id])
    respond_to do |format|
      format.html
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{DistributionCost.model_name.human}_#{session[:year]}_#{session[:month]}.xls\"" }
      format.xls_empty {
        headers["Content-Disposition"] = "attachment; filename=\"Format_#{DistributionCost.model_name.human}_#{session[:year]}_#{session[:month]}.xls\""
      }
    end
  end

  def save_distribution_costs
    distribution_cost = DistributionCost.find_or_initialize_by(year: params[:year], month: params[:month],
                                                               entity_id: session[:entity_id], cost_center_id: params[:cost_center],
                                                               supported_cost_center_id: params[:supported_cost_center],
                                                               production_units: params[:production_units])
    distribution_cost.year = params[:year]
    distribution_cost.month = params[:month]
    distribution_cost.entity_id = session[:entity_id]
    distribution_cost.supported_cost_center_id = params[:supported_cost_center]
    distribution_cost.cost_center_id = params[:cost_center]
    distribution_cost.production_units = params[:production_units]
    distribution_cost.value = params[:value]
    if not distribution_cost.save
      return render :json => distribution_cost.errors.to_json, :status => 400
    end
    render :json => 'ok'.to_json, :status => 200
  end

  # POST /distribution_costs/import
  def import
    if params[:empty_format]
      DistributionCost.where(entity_id: session['entity_id'], year: session[:year], month: session[:month]).destroy_all
    end

    message = DistributionCost.import(params[:file], session[:year], session[:month], session[:entity_id])
    redirect_to distribution_costs_url, notice: message
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distribution_cost
      @distribution_cost = DistributionCost.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distribution_cost_params
      params.require(:distribution_cost).permit(:year, :month, :value, :cost_center_id, :supported_cost_center_id, :entity_id)
    end
end
