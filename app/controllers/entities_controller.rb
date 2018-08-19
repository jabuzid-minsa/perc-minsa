class EntitiesController < ApplicationController
  before_action :set_entity, only: [:show, :edit, :update, :destroy, :associations]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern, GeographiesConcern, LanguagesConcern

  # GET /entities
  # GET /entities.json
  def index
    if session[:country_id].present?
      country = Geography.find(session[:country_id])
    elsif current_user.is_valid_geography
      country = Geography.find(current_user.geography_id)
    end
    if current_user.is_global_administrator? && session[:country_id].present?
      @entities = Entity.available_for_country(country.numerical_code)
    elsif current_user.is_global_administrator?
      @entities = Entity.all
    elsif current_user.is_basic_administrator?
      @entities = Entity.active.for_users(current_user.id)
    else
      @entities = Entity.available_for_country(country.numerical_code)
    end
  end

  # GET /entities/1
  # GET /entities/1.json
  def show
  end

  # GET /entities/new
  def new
    @entity = Entity.new
    @entity.code = Entity.last.code.to_i + 1
  end

  # GET /entities/1/edit
  def edit
  end

  # POST /entities
  # POST /entities.json
  def create
    @entity = Entity.new(entity_params)
    unless Entity.find_by(code: @entity.code, geography_id: @entity.geography_id).present?
      @entity.code = Entity.last.code.to_i + 1
    end

    respond_to do |format|
      if @entity.save
        format.html { redirect_to entity_associations_path(@entity), notice: get_message_created(Entity) }
        format.json { render :show, status: :created, location: @entity }
      else
        format.html { render :new }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entities/1
  # PATCH/PUT /entities/1.json
  def update
    respond_to do |format|
      if @entity.update(entity_params)
        format.html { redirect_to entities_url, notice: get_message_updated(Entity) }
        format.json { render :show, status: :ok, location: @entity }
      else
        format.html { render :edit }
        format.json { render json: @entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entities/1
  # DELETE /entities/1.json
  def destroy
    @entity.destroy
    respond_to do |format|
      format.html { redirect_to entities_url, notice: get_message_destroyed(Entity) }
      format.json { head :no_content }
    end
  end

=begin
  Section of non-crud methods
=end

  #
  def belongs_to_location
    filter = { first_level: params[:first_level] }
    if params[:second_level].to_i > 0
      filter[:second_level] = params[:second_level]
    end

    if params[:third_level].to_i > 0
      filter[:third_level] = params[:third_level]
    end

    if params[:fourth_level].to_i > 0
      filter[:fourth_level] = params[:fourth_level]
    end

    if params[:fifth_level].to_i > 0
      filter[:fifth_level] = params[:fifth_level]
    end
    entities = Entity.joins(:geography).where(:geographies => filter)
    render :json => entities.to_json, :status => 200
  end

  # Change between the different entities created
  def change_entity
    session[:entity_id] = params[:entity_id].present? ? params[:entity_id] : 0
    render :json => t('change_entity').to_json, :status => 200
  end

  #
  def associations
    @cost_centers = CostCenter.selectable.active
    @staffs = Staff.selectable.active
    @supplies = Supply.selectable.active
  end

  #
  def create_associations
    entity = Entity.find(params[:entity_id])
    case params[:model]
      when 'cost_center'
        cost_center = CostCenter.find(params[:relation_id])
        entity.entity_cost_centers.create(cost_center_id: cost_center.id,
                                          function: params[:function_service])
        IncomeDefinition.create(entity_id: entity.id, cost_center_id: cost_center.id)
      when 'supply'
        supply = Supply.find(params[:relation_id])
        entity.supplies << supply
      when 'staff'
        staff = Staff.find(params[:relation_id])
        entity.staffs << staff
    end
    render :json => 'Terminado'.to_json, :status => 200
  end

  #
  def destroy_associations
    entity = Entity.find(params[:entity_id])
    case params[:model]
      when 'cost_center'
        cost_center = CostCenter.find(params[:relation_id])
        entity.cost_centers.delete(cost_center)
        income_definition = IncomeDefinition.where(entity_id: entity.id, cost_center_id: cost_center.id)
        if income_definition.present?
          income_definition.destroy
        end
      when 'supply'
        supply = Supply.find(params[:relation_id])
        entity.supplies.delete(supply)
      when 'staff'
        staff = Staff.find(params[:relation_id])
        entity.staffs.delete(staff)
    end
    render :json => 'Terminado'.to_json, :status => 200
  end

  def get_entity_for_country
    entities = Entity.active.available_for_country(params[:numerical_code])
    render :json => entities.to_json, :status => 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entity
      @entity = Entity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entity_params
      params.require(:entity).permit(:code, :abbreviation, :description, :payroll_type, :care_level_id, :geography_id, :state)
    end
end
