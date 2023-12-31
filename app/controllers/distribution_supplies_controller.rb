class DistributionSuppliesController < ApplicationController
  before_action :set_distribution_supply, only: [:show, :edit, :update, :destroy]

  # GET /distribution_supplies
  # GET /distribution_supplies.json
  def index
    @supplies = Supply.active.for_entity(session[:entity_id]).where('supplies.supplies_category_id = ?', 1)
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

    GenerateReportJob.perform_later(3, session[:year], session[:month], session['entity_id'])

    redirect_to distribution_supplies_url, notice: "Archivo Importado."
  end

  # POST /distribution_supplies/get_supply
  def info_supply
    if params[:type] == 'single'
      cost = DistributionSupply.where(year: session[:year], month: session[:month], entity_id: session[:entity_id], supply_id: params[:supply]).sum(:value)
    else
      end_date = Date.civil((session[:date_end].split('/')[1]).to_i, (session[:date_end].split('/')[0]).to_i, -1)        
      star_date = Date.strptime("#{session[:date_start].split('/')[1]}-#{session[:date_start].split('/')[0]}-01", '%Y-%m-%d')
      cost = DistributionSupply.where(entity_id: session[:entity_id], supply_id: params[:supply])
                                .where("CAST(CONCAT(year, '-', month, '-1') AS DATE) BETWEEN CAST('#{star_date}' AS DATE) AND CAST('#{end_date}' AS DATE)")
                                .sum(:value)
    end

    render json: cost, status: :ok
  rescue Exception => e
    render json: ['Error'], status: :bad
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
