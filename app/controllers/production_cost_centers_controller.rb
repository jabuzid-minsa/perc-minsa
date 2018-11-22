class ProductionCostCentersController < ApplicationController
  before_action :set_production_cost_center, only: [:show, :edit, :update, :destroy]

  # GET /production_cost_centers
  # GET /production_cost_centers.json
  def index
    @cost_centers = CostCenter.for_entity(session[:entity_id]).finals.order_priority.order(:code)    
    @production_cost_centers = ProductionCostCenter.date(session[:year], session[:month]).for_entity(session[:entity_id])
    respond_to do |format|
      format.html
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{ProductionCostCenter.model_name.human}_#{session[:year]}_#{session[:month]}.xls\"" }
      format.xls_empty {
        headers["Content-Disposition"] = "attachment; filename=\"Format_#{ProductionCostCenter.model_name.human}_#{session[:year]}_#{session[:month]}.xls\""
      }
    end
  end

  def save_production_cost_centers
    production_cost_center = ProductionCostCenter.find_or_initialize_by(year: params[:year], month: params[:month],
                                                                        entity_id: session[:entity_id], cost_center_id: params[:cost_center],
                                                                        production_units: params[:production_units])
    production_cost_center.year = params[:year]
    production_cost_center.month = params[:month]
    production_cost_center.entity_id = session[:entity_id]
    production_cost_center.cost_center_id = params[:cost_center]
    production_cost_center.production_units = params[:production_units]
    production_cost_center.value = params[:value]
    if not production_cost_center.save
      return render :json => production_cost_center.errors.to_json, :status => 400
    end
    render :json => 'ok'.to_json, :status => 200
  end

  # POST /payrolls/import
  def import
    if params[:empty_format]
      ProductionCostCenter.where(entity_id: session['entity_id'], year: session[:year], month: session[:month]).destroy_all
    end

    message = ProductionCostCenter.import(params[:file], session[:year], session[:month], session['entity_id'])

    GenerateReportJob.perform_later(5, session[:year], session[:month], session['entity_id'])

    redirect_to production_cost_centers_url, notice: message
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_production_cost_center
      @production_cost_center = ProductionCostCenter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def production_cost_center_params
      params.require(:production_cost_center).permit(:year, :month, :value, :production_units, :cost_center_id, :entity_id)
    end
end
