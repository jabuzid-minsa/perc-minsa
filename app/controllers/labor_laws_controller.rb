class LaborLawsController < ApplicationController
  before_action :set_labor_law, only: [:show, :edit, :update, :destroy]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern, GeographiesConcern, LanguagesConcern

  # GET /labor_laws
  # GET /labor_laws.json
  def index
    redirect_to root_path, alert: 'Seleccione una entidad' if !session[:entity_id].present? or session[:entity_id].to_i < 1
    @labor_laws = LaborLaw.where(entity_id: session[:entity_id], year: session[:year], month: session[:month])
  end

  # GET /labor_laws/1
  # GET /labor_laws/1.json
  def show
  end

  # GET /labor_laws/new
  def new
    @labor_law = LaborLaw.new
  end

  # GET /labor_laws/1/edit
  def edit
  end

  # POST /labor_laws
  # POST /labor_laws.json
  def create
    @labor_law = LaborLaw.new(labor_law_params)

    respond_to do |format|
      if @labor_law.save
        format.html { redirect_to new_labor_law_path, notice: get_message_created(LaborLaw) }
        format.json { render :show, status: :created, location: @labor_law }
      else
        format.html { render :new }
        format.json { render json: @labor_law.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /labor_laws/1
  # PATCH/PUT /labor_laws/1.json
  def update
    respond_to do |format|
      #if @labor_law.update(clean_numbers(labor_law_params))
      if @labor_law.update(labor_law_params)
        format.html { redirect_to labor_laws_path, notice: get_message_updated(LaborLaw) }
        format.json { render :show, status: :ok, location: @labor_law }
      else
        format.html { render :edit }
        format.json { render json: @labor_law.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /labor_laws/1
  # DELETE /labor_laws/1.json
  def destroy
    @labor_law.destroy
    respond_to do |format|
      format.html { redirect_to labor_laws_url, notice: 'Labor law was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def standard_configuration
    labor_standard = LaborStandard.find_by(geography_id: session['country_id'])
    if not labor_standard.present?
      LaborStandard.create(code: '00', description: 'Base', geography_id: session['country_id'])
    end

    ActiveRecord::Base.connection.exec_query("CALL create_labor_laws(#{session[:year]},#{session[:month]}, #{session[:entity_id]}, #{session['country_id']})")
    ActiveRecord::Base.clear_active_connections!

    redirect_to labor_laws_url, notice: 'Datos Creados'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_labor_law
    @labor_law = LaborLaw.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def labor_law_params
    data = params.require(:labor_law).permit(:year, :month, :min_wage, :staff_id, :labor_standard_id, :contract_type_id, :entity_id, :salary_component_ids => [])
    data[:min_wage] = data[:min_wage].gsub(',', '')
    return data
  end
end
