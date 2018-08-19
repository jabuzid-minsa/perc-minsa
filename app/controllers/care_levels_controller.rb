class CareLevelsController < ApplicationController
  before_action :set_care_level, only: [:show, :edit, :update, :destroy]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern, GeographiesConcern, LanguagesConcern, ValidationsConcern

  # GET /care_levels
  # GET /care_levels.json
  def index
    @care_levels = get_model_by_country_allowed(CareLevel).idiom(get_current_idiom)
  end

  # GET /care_levels/1
  # GET /care_levels/1.json
  def show
  end

  # GET /care_levels/new
  def new
    @care_level = CareLevel.new
    @care_level.code = next_code_simple_model(CareLevel)
  end

  # GET /care_levels/1/edit
  def edit
  end

  # POST /care_levels
  # POST /care_levels.json
  def create
    @care_level = CareLevel.new(care_level_params)

    respond_to do |format|
      if @care_level.save
        format.html { redirect_to new_care_level_url, notice: get_message_created(CareLevel) }
        format.json { render :show, status: :created, location: @care_level }
      else
        format.html { render :new }
        format.json { render json: @care_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /care_levels/1
  # PATCH/PUT /care_levels/1.json
  def update
    respond_to do |format|
      if @care_level.update(care_level_params)
        format.html { redirect_to care_levels_url, notice: get_message_updated(CareLevel) }
        format.json { render :show, status: :ok, location: @care_level }
      else
        format.html { render :edit }
        format.json { render json: @care_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /care_levels/1
  # DELETE /care_levels/1.json
  def destroy
    @care_level.destroy
    respond_to do |format|
      format.html { redirect_to care_levels_url, notice: get_message_destroyed(CareLevel) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_care_level
      @care_level = CareLevel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def care_level_params
      params.require(:care_level).permit(:code, :description, :definition, :geography_id, :language_id, :state)
    end
end
