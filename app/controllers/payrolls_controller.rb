class PayrollsController < ApplicationController
  before_action :set_payroll, only: [:show, :edit, :update, :destroy]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern, GeographiesConcern

  # GET /payrolls
  # GET /payrolls.json
  def index
    @consolidated = Entity.find(session[:entity_id]).payroll_type == 'consolidated'
    @payrolls = Payroll.date(session[:year], session[:month]).for_entity(session[:entity_id])
    respond_to do |format|
      format.html
      format.csv { send_data @payrolls.to_csv(true), filename: "#{Payroll.model_name.human}_#{session[:year]}_#{session[:month]}.csv" }
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{Payroll.model_name.human}_#{session[:year]}_#{session[:month]}.xls\"" }
      format.xls_empty {
        headers["Content-Disposition"] = "attachment; filename=\"Format_#{Payroll.model_name.human}_#{session[:year]}_#{session[:month]}.xls\""
      }
    end
  end

  # GET /payrolls/1
  # GET /payrolls/1.json
  def show
  end

  # GET /payrolls/new
  def new
    if not LaborLaw.find_by(year: session[:year], month: session[:month], entity_id: session[:entity_id]).present?
      labor_standard = LaborStandard.find_by(geography_id: session['country_id'])
      if not labor_standard.present?
        LaborStandard.create(code: '00', description: 'Base', geography_id: session['country_id'])
      end

      ActiveRecord::Base.connection.exec_query("CALL create_labor_laws(#{session[:year]},#{session[:month]}, #{session[:entity_id]}, #{session['country_id']})")
      ActiveRecord::Base.clear_active_connections!
    end
    @payroll = Payroll.new
    @consolidated = Entity.find(session[:entity_id]).payroll_type == 'consolidated'
  end

  # GET /payrolls/1/edit
  def edit
  end

  # POST /payrolls
  # POST /payrolls.json
  def create
    @payroll = Payroll.new(payroll_params)
    @payroll.year = session[:year]
    @payroll.month = session[:month]
    if Entity.find(session[:entity_id]).payroll_type == 'consolidated'
      max_dni = Payroll.where(entity_id: session[:entity_id], year: session[:year], month: session[:month]).order(dni: :desc).first.dni
      @payroll.dni = max_dni ? max_dni.to_i + 1 : 1
    end
    respond_to do |format|
      if @payroll.save
        format.html { redirect_to new_payroll_path, notice: get_message_created(Payroll) }
        format.json { render :show, status: :created, location: @payroll }
      else
        format.html { render :new }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payrolls/1
  # PATCH/PUT /payrolls/1.json
  def update
    @payroll.year = session[:year]
    @payroll.month = session[:month]
    respond_to do |format|
      if @payroll.update(payroll_params)
        format.html { redirect_to payrolls_path, notice: get_message_updated(Payroll) }
        format.json { render :show, status: :ok, location: @payroll }
      else
        format.html { render :edit }
        format.json { render json: @payroll.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payrolls/1
  # DELETE /payrolls/1.json
  def destroy
    @payroll.destroy
    respond_to do |format|
      format.html { redirect_to payrolls_url, notice: get_message_destroyed(Payroll) }
      format.json { head :no_content }
    end
  end

  # POST /payrolls/import
  def import
    if params[:empty_format]
      ProgrammingHour.where(entity_id: session['entity_id'], year: session[:year], month: session[:month]).destroy_all
      Payroll.where(entity_id: session['entity_id'], year: session[:year], month: session[:month]).destroy_all
    end

    if not LaborLaw.find_by(year: session[:year], month: session[:month], entity_id: session[:entity_id]).present?
      labor_standard = LaborStandard.find_by(geography_id: session['country_id'])
      if not labor_standard.present?
        LaborStandard.create(code: '00', description: 'Base', geography_id: session['country_id'])
      end
    end
    
    ActiveRecord::Base.connection.exec_query("CALL create_labor_laws(#{session[:year]},#{session[:month]}, #{session[:entity_id]}, #{session['country_id']})")
    ActiveRecord::Base.clear_active_connections!

    message = Payroll.import(params[:file], session[:year], session[:month], session['entity_id'], session['country_id'], Entity.find(session[:entity_id]).payroll_type)

    redirect_to payrolls_url, notice: message
  end

  def validate_dates_for_entity
    if session[:entity_id].present?
      dates = Payroll.where(entity_id: session[:entity_id]).select('DISTINCT year, month').order('year, month')
      render json: dates.to_json, status: 200
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payroll
      @payroll = Payroll.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payroll_params
      data = params.require(:payroll).permit(:dni, :name, :salary, :bonuses, :benefits, :labor_law_id, :entity_id)
      data[:salary] = data[:salary].gsub(',', '')
      data[:bonuses] = data[:bonuses].gsub(',', '')
      data[:benefits] = data[:benefits].gsub(',', '')
      return data
    end
end
