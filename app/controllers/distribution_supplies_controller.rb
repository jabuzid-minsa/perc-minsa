class DistributionSuppliesController < ApplicationController
  before_action :set_distribution_supply, only: [:show, :edit, :update, :destroy]

  # GET /distribution_supplies
  # GET /distribution_supplies.json
  def index
    @supplies = Supply.active.for_entity(session[:entity_id]).where('supplies.code LIKE ?', '%002%')
    @cost_centers = CostCenter.for_entity(session[:entity_id]).order_priority.order(:code)
    @distribution_supplies = DistributionSupply.date(session[:year], session[:month]).for_entity(session[:entity_id])
    respond_to do |format|
      format.html
      format.csv { send_data @distribution_supplies.to_csv(true), filename: "#{DistributionSupply.model_name.human}_#{session[:year]}_#{session[:month]}.csv" }
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{DistributionSupply.model_name.human}_#{session[:year]}_#{session[:month]}.xls\"" }
      format.xls_empty {
        headers["Content-Disposition"] = "attachment; filename=\"Format_#{DistributionSupply.model_name.human}_#{session[:year]}_#{session[:month]}.xls\""
      }
    end
  end

  def save_distribution_supplies
    distribution_supply = DistributionSupply.find_or_initialize_by(year: params[:year], month: params[:month],
                                                             entity_id: session[:entity_id], cost_center_id: params[:cost_center],
                                                                supply_id: params[:supply])
    distribution_supply.year = params[:year]
    distribution_supply.month = params[:month]
    distribution_supply.entity_id = session[:entity_id]
    distribution_supply.cost_center_id = params[:cost_center]
    distribution_supply.supply_id = params[:supply]
    distribution_supply.value = params[:value]
    if not distribution_supply.save
      return render :json => distribution_supply.errors.to_json, :status => 400
    end
    render :json => 'ok'.to_json, :status => 200
  end

  # POST /payrolls/import
  def import
    if params[:empty_format]
      DistributionSupply.where(entity_id: session['entity_id'], year: session[:year], month: session[:month]).destroy_all
    end

    DistributionSupply.import(params[:file], session[:year], session[:month], session[:entity_id])
    redirect_to distribution_supplies_url, notice: "Archivo Importado."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distribution_supply
      @distribution_supply = DistributionSupply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distribution_supply_params
      params.require(:distribution_supply).permit(:year, :month, :value, :supply_id, :cost_center_id, :entity_id)
    end
end
