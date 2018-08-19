class ProductionUnitsController < ApplicationController
  before_action :set_production_unit, only: [:show, :edit, :update, :destroy]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern, GeographiesConcern, LanguagesConcern, ValidationsConcern

  # GET /production_units
  # GET /production_units.json
  def index
    @production_units = get_model_by_country_allowed(ProductionUnit).idiom(get_current_idiom)
  end

  # GET /production_units/1
  # GET /production_units/1.json
  def show
  end

  # GET /production_units/new
  def new
    @production_unit = ProductionUnit.new
    @production_unit.code = next_code_simple_model(ProductionUnit)
  end

  # GET /production_units/1/edit
  def edit
  end

  # POST /production_units
  # POST /production_units.json
  def create
    @production_unit = ProductionUnit.new(production_unit_params)

    respond_to do |format|
      if @production_unit.save
        format.html { redirect_to new_production_unit_url, notice: get_message_created(ProductionUnit) }
        format.json { render :show, status: :created, location: @production_unit }
      else
        format.html { render :new }
        format.json { render json: @production_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /production_units/1
  # PATCH/PUT /production_units/1.json
  def update
    respond_to do |format|
      if @production_unit.update(production_unit_params)
        format.html { redirect_to production_units_url, notice: get_message_updated(ProductionUnit) }
        format.json { render :show, status: :ok, location: @production_unit }
      else
        format.html { render :edit }
        format.json { render json: @production_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /production_units/1
  # DELETE /production_units/1.json
  def destroy
    @production_unit.destroy
    respond_to do |format|
      format.html { redirect_to production_units_url, notice: get_message_destroyed(ProductionUnit) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_production_unit
      @production_unit = ProductionUnit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def production_unit_params
      params.require(:production_unit).permit(:code, :abbreviation, :description, :definition, :geography_id, :language_id, :state)
    end
end
