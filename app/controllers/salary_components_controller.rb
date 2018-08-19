class SalaryComponentsController < ApplicationController
  before_action :set_salary_component, only: [:show, :edit, :update, :destroy]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern, GeographiesConcern

  # GET /salary_components
  # GET /salary_components.json
  def index
    @salary_components = SalaryComponent.available_for_country(get_country_valid_by_user('numerical_code'))
  end

  # GET /salary_components/1
  # GET /salary_components/1.json
  def show
  end

  # GET /salary_components/new
  def new
    @salary_component = SalaryComponent.new
  end

  # GET /salary_components/1/edit
  def edit
  end

  # POST /salary_components
  # POST /salary_components.json
  def create
    @salary_component = SalaryComponent.new(salary_component_params)

    respond_to do |format|
      if @salary_component.save
        format.html { redirect_to new_salary_component_path, notice: get_message_created(SalaryComponent) }
        format.json { render :show, status: :created, location: @salary_component }
      else
        format.html { render :new }
        format.json { render json: @salary_component.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /salary_components/1
  # PATCH/PUT /salary_components/1.json
  def update
    respond_to do |format|
      if @salary_component.update(salary_component_params)
        format.html { redirect_to salary_components_path, notice: get_message_updated(SalaryComponent) }
        format.json { render :show, status: :ok, location: @salary_component }
      else
        format.html { render :edit }
        format.json { render json: @salary_component.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /salary_components/1
  # DELETE /salary_components/1.json
  def destroy
    @salary_component.destroy
    respond_to do |format|
      format.html { redirect_to salary_components_url, notice: get_message_destroyed(SalaryComponent) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_salary_component
      @salary_component = SalaryComponent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def salary_component_params
      data = params.require(:salary_component).permit(:code, :abbreviation, :description, :max_value, :rate, :geography_id, :state)
      data[:max_value] = data[:max_value].gsub(',', '')
      data[:rate] = data[:rate].gsub(',', '')
      return data
    end
end
