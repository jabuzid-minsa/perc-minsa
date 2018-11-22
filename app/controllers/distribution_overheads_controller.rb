class DistributionOverheadsController < ApplicationController
  before_action :set_distribution_overhead, only: [:show, :edit, :update, :destroy]

  # Load abilities for current user
  load_and_authorize_resource

  # GET /distribution_overheads
  # GET /distribution_overheads.json
  def index
    @cost_centers = CostCenter.for_entity(session[:entity_id]).order_priority.order(:code)
    @total_cost_center = @cost_centers.count + 1
    @supplies = Supply.for_entity(session[:entity_id]).where('supplies.supplies_category_id = ?', 2).order(:description)
    @type_distributions = TypeDistribution.active.idiom
    @distribution_overheads = DistributionOverhead.date(session[:year], session[:month]).for_entity(session[:entity_id])
    respond_to do |format|
      format.html
      format.csv { send_data @distribution_supplies.to_csv(true), filename: "#{DistributionOverhead.model_name.human}_#{session[:year]}_#{session[:month]}.csv" }
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{DistributionOverhead.model_name.human}_#{session[:year]}_#{session[:month]}.xls\"" }
      format.xls_empty {
        headers["Content-Disposition"] = "attachment; filename=\"Format_#{DistributionOverhead.model_name.human}_#{session[:year]}_#{session[:month]}.xls\""
      }
    end
  end

  def save_distribution_overheads
    distribution_overhead = DistributionOverhead.find_or_initialize_by(year: params[:year], month: params[:month],
                                                                   entity_id: session[:entity_id], cost_center_id: params[:cost_center],
                                                                   supply_id: params[:supply])

    distribution_overhead.year = params[:year]
    distribution_overhead.month = params[:month]
    distribution_overhead.entity_id = session[:entity_id]
    distribution_overhead.cost_center_id = params[:cost_center]
    distribution_overhead.supply_id = params[:supply]
    distribution_overhead.type_distribution_id = params[:type_distribution]
    distribution_overhead.general_value = params[:general_value]
    distribution_overhead.value = params[:value]
    if not distribution_overhead.save
      return render :json => distribution_overhead.errors.to_json, :status => 400
    end
    render :json => 'ok'.to_json, :status => 200
  end

  def update_type_distributions
    DistributionOverhead.where(year: params[:year], month: params[:month], entity_id: session[:entity_id],
                               supply_id: params[:supply]).update_all(type_distribution_id: params[:type_distribution])

    render :json => 'ok'.to_json, :status => 200
  end

  def update_general_values
    DistributionOverhead.where(year: params[:year], month: params[:month], entity_id: session[:entity_id],
                               supply_id: params[:supply]).update_all(general_value: params[:general_value])

    render :json => 'ok'.to_json, :status => 200
  end

  # POST /distribution_overheads/import
  def import
    if params[:empty_format]
      DistributionOverhead.where(entity_id: session['entity_id'], year: session[:year], month: session[:month]).destroy_all
    end

    DistributionOverhead.import(params[:file], session[:year], session[:month], session[:entity_id])

    GenerateReportJob.perform_later(2, session[:year], session[:month], session['entity_id'])

    redirect_to distribution_overheads_url, notice: "Archivo Importado."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distribution_overhead
      @distribution_overhead = DistributionOverhead.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distribution_overhead_params
      params.require(:distribution_overhead).permit(:year, :month, :general_value, :value, :type_distribution_id, :cost_center_id, :supply_id, :entity_id)
    end
end
