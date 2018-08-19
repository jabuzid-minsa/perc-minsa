class DistributionAreasController < ApplicationController

  # GET /distribution_areas
  # GET /distribution_areas.json
  def index
    @cost_centers = CostCenter.active.for_entity(session[:entity_id]).order_priority.order(:code)
    @distribution_areas = DistributionArea.date(session[:year], session[:month]).for_entity(session[:entity_id])

    respond_to do |format|
      format.html
      format.csv { send_data @distribution_areas.to_csv(true), filename: "#{DistributionArea.model_name.human}_#{session[:year]}_#{session[:month]}.csv" }
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{DistributionArea.model_name.human}_#{session[:year]}_#{session[:month]}.xls\"" }
      format.xls_empty {
        headers["Content-Disposition"] = "attachment; filename=\"Format_#{DistributionArea.model_name.human}_#{session[:year]}_#{session[:month]}.xls\""
      }
    end
  end

  def save_meters
    distribution_area = DistributionArea.find_or_initialize_by(year: params[:year], month: params[:month],
                                                               entity_id: session[:entity_id], cost_center_id: params[:cost_center])
    distribution_area.year = params[:year]
    distribution_area.month = params[:month]
    distribution_area.entity_id = session[:entity_id]
    distribution_area.cost_center_id = params[:cost_center]
    distribution_area.meters = params[:meters]
    if not distribution_area.save
      return render :json => distribution_area.errors.to_json, :status => 400
    end
    render :json => 'ok'.to_json, :status => 200
  end

  # POST /distribution_areas/import
  def import
    if params[:empty_format]
      DistributionArea.where(entity_id: session['entity_id'], year: session[:year], month: session[:month]).destroy_all
    end
    
    message = DistributionArea.import(params[:file], session[:year], session[:month], session['entity_id'])
    redirect_to distribution_areas_url, notice: message
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distribution_area
      @distribution_area = DistributionArea.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distribution_area_params
      params.require(:distribution_area).permit(:year, :month, :meters, :entity_id, :cost_center_id)
    end
end
