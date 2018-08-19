class SuppliesController < ApplicationController
  before_action :set_supply, only: [:show, :edit, :update, :destroy]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern, GeographiesConcern, LanguagesConcern, ValidationsConcern

  # GET /supplies
  # GET /supplies.json
  def index
    @supplies = get_model_by_country_allowed(Supply).idiom(get_current_idiom)
  end

  # GET /supplies/1
  # GET /supplies/1.json
  def show
  end

  # GET /supplies/new
  def new
    @supply = Supply.new
    @supply.code = next_code_model(Supply, 'supply_id', nil)
  end

  # GET /supplies/1/edit
  def edit
  end

  # POST /supplies
  # POST /supplies.json
  def create
    @supply = Supply.new(supply_params)

    respond_to do |format|
      if @supply.save
        format.html { redirect_to new_supply_url, notice: get_message_created(Supply) }
        format.json { render :show, status: :created, location: @supply }
      else
        format.html { render :new }
        format.json { render json: @supply.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supplies/1
  # PATCH/PUT /supplies/1.json
  def update
    respond_to do |format|
      if @supply.update(supply_params)
        format.html { redirect_to supplies_url, notice: get_message_updated(Supply) }
        format.json { render :show, status: :ok, location: @supply }
      else
        format.html { render :edit }
        format.json { render json: @supply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supplies/1
  # DELETE /supplies/1.json
  def destroy
    @supply.destroy
    respond_to do |format|
      format.html { redirect_to supplies_url, notice: get_message_destroyed(Supply) }
      format.json { head :no_content }
    end
  end

  def ajax_next_code
    supply_id = params[:supply] == '' ? nil : params[:supply]
    code = next_code_model(Supply, 'supply_id', supply_id)
    render :json => code.to_json, :status => 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supply
      @supply = Supply.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supply_params
      params.require(:supply).permit(:code, :description, :definition, :supply_id, :supplies_category_id, :geography_id, :language_id, :state)
    end
end
