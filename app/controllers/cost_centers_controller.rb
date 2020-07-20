class CostCentersController < ApplicationController
  before_action :set_cost_center, only: [:show, :edit, :update, :destroy]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern, GeographiesConcern, LanguagesConcern, ValidationsConcern

  # GET /cost_centers
  # GET /cost_centers.json
  def index
    @cost_centers = get_model_by_country_allowed(CostCenter).idiom(get_current_idiom)

    respond_to do |format|
      format.html
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{CostCenter.model_name.human}.xls\"" }
    end
  end

  # GET /cost_centers/1
  # GET /cost_centers/1.json
  def show
  end

  # GET /cost_centers/new
  def new
    @cost_center = CostCenter.new
    @cost_center.code = next_code_model(CostCenter, 'cost_center_id', nil)
  end

  # GET /cost_centers/1/edit
  def edit
  end

  # POST /cost_centers
  # POST /cost_centers.json
  def create
    @cost_center = CostCenter.new(cost_center_params)

    respond_to do |format|
      if @cost_center.save
        format.html { redirect_to new_cost_center_url, notice: get_message_created(CostCenter) }
        format.json { render :show, status: :created, location: @cost_center }
      else
        format.html { render :new }
        format.json { render json: @cost_center.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cost_centers/1
  # PATCH/PUT /cost_centers/1.json
  def update
    respond_to do |format|
      if @cost_center.update(cost_center_params)
        format.html { redirect_to cost_centers_url, notice: get_message_updated(CostCenter) }
        format.json { render :show, status: :ok, location: @cost_center }
      else
        format.html { render :edit }
        format.json { render json: @cost_center.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cost_centers/1
  # DELETE /cost_centers/1.json
  def destroy
    @cost_center.destroy
    respond_to do |format|
      format.html { redirect_to cost_centers_url, notice: get_message_destroyed(CostCenter) }
      format.json { head :no_content }
    end
  end

  #
  def search_available_cost_centers_to_relate
    country_ids ||= [params[:current_country_id]]
    country_ids << Geography.record_all_countries.first.id

    cost_centers = CostCenter.active.selectable.available_for_country(country_ids).cost_centers_available(params[:entity_id])
    render json: cost_centers.to_json, status: 200
  end

  def ajax_next_code
    cost_center_id = params[:cost_center] == '' ? nil : params[:cost_center]
    code = next_code_model(CostCenter, 'cost_center_id', cost_center_id)
    render :json => code.to_json, :status => 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cost_center
      @cost_center = CostCenter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cost_center_params
      params.require(:cost_center).permit(:code, :description, :definition, :function, :cost_center_id, :geography_id, :language_id, :staff_id, :supply_id, :cost_distribution_id, :primary_production_unit_id, :secondary_production_unit_id, :tertiary_production_unit_id, :quaternary_production_unit_id, :quinary_production_unit_id, :state, :comprehensive, :secondary_equivalent_to_primary, :tertiary_equivalent_to_primary, :quaternary_equivalent_to_primary, :quinary_equivalent_to_primary, :type_group)
    end
end
