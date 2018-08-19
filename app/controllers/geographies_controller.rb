class GeographiesController < ApplicationController
  before_action :set_geography, only: [:show, :edit, :update, :destroy]
  before_action :set_country, only: [:index, :new, :create, :edit, :update]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern

  # GET /geographies
  # GET /geographies.json
  def index
    if current_user.is_valid_geography? or current_user.is_valid_session_country?(session[:country_id])
      if current_user.is_valid_geography?
        country_code = Geography.find(current_user.geography_id).first_level
      elsif current_user.is_valid_session_country?(session[:country_id])
        country_code = Geography.find(session['country_id']).first_level
      end
      @geographies = selection_of_levels_by_country(country_code)
    else
      @geographies = Geography.countries
    end
  end

  # GET /geographies/1
  # GET /geographies/1.json
  def show
  end

  # GET /geographies/new
  def new
    @geography = Geography.new
  end

  # GET /geographies/1/edit
  def edit
  end

  # POST /geographies
  # POST /geographies.json
  def create
    @geography = Geography.new(geography_params)

    respond_to do |format|
      if @geography.save
        format.html { redirect_to new_geography_url, notice: get_message_created(Geography) }
        format.json { render :show, status: :created, location: @geography }
      else
        format.html { render :new }
        format.json { render json: @geography.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /geographies/1
  # PATCH/PUT /geographies/1.json
  def update
    respond_to do |format|
      if @geography.update(geography_params)
        format.html { redirect_to geographies_url, notice: get_message_updated(Geography) }
        format.json { render :show, status: :ok, location: @geography }
      else
        format.html { render :edit }
        format.json { render json: @geography.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /geographies/1
  # DELETE /geographies/1.json
  def destroy
    @geography.destroy
    respond_to do |format|
      format.html { redirect_to geographies_url, notice: get_message_destroyed(Geography) }
      format.json { head :no_content }
    end
  end

=begin
  Section of non-crud methods
=end

  # Change between the different countries created
  def change_country
    session[:country_id] = params[:country_id].present? ? params[:country_id] : 1
    session.delete(:network_id)
    session.delete(:entity_id)
    session.delete(:year)
    session.delete(:month)
    render :json => t('app.change_date').to_json, :status => 200
  end

  def get_third_level
    @data = Geography.departments.active.where(first_level: params[:first_level], second_level: params[:second_level])
    render :json => @data.to_json, :status => 200
  end

  def get_fourth_level
    @data = Geography.municipalities.active.where(first_level: params[:first_level], second_level: params[:second_level],
                                                  third_level: params[:third_level])
    render :json => @data.to_json, :status => 200
  end

  def get_fifth_level
    @data = Geography.towns.active.where(first_level: params[:first_level], second_level: params[:second_level],
                                         third_level: params[:third_level], fourth_level: params[:fourth_level])
    render :json => @data.to_json, :status => 200
  end

  def create_second_level
    new_level = Geography.new
    new_level.numerical_code = params[:numerical_code]
    new_level.first_level = params[:first_level]
    new_level.second_level = params[:code].to_i
    new_level.description = params[:description]
    if new_level.save
      render :json => new_level.to_json, :status => 200
    else
      render json: new_level.errors.full_messages.to_json, status: :unprocessable_entity
    end
  end

  def create_third_level
    new_level = Geography.new
    new_level.numerical_code = params[:numerical_code]
    new_level.first_level = params[:first_level]
    new_level.second_level = params[:second_level].to_i
    new_level.third_level = params[:code].to_i
    new_level.description = params[:description]
    if new_level.save
      render :json => new_level.to_json, :status => 200
    else
      render json: new_level.errors.full_messages.to_json, status: :unprocessable_entity
    end
  end

  def create_fourth_level
    new_level = Geography.new
    new_level.numerical_code = params[:numerical_code]
    new_level.first_level = params[:first_level]
    new_level.second_level = params[:second_level].to_i
    new_level.third_level = params[:third_level].to_i
    new_level.fourth_level = params[:code].to_i
    new_level.description = params[:description]
    if new_level.save
      render :json => new_level.to_json, :status => 200
    else
      render json: new_level.errors.full_messages.to_json, status: :unprocessable_entity
    end
  end

  def create_fifth_level
    new_level = Geography.new
    new_level.numerical_code = params[:numerical_code]
    new_level.first_level = params[:first_level]
    new_level.second_level = params[:second_level].to_i
    new_level.third_level = params[:third_level].to_i
    new_level.fourth_level = params[:fourth_level].to_i
    new_level.fifth_level = params[:code].to_i
    new_level.description = params[:description]
    if new_level.save
      render :json => new_level.to_json, :status => 200
    else
      render json: new_level.errors.full_messages.to_json, status: :unprocessable_entity
    end
  end

  #
  def validate_unique_code
    geography = Geography.find_by(numerical_code: params[:numerical_code], second_level: params[:second_level],
                                  third_level: params[:third_level], fourth_level: params[:fourth_level],
                                  fifth_level: params[:fifth_level])

    if geography.present?
      render :json => false.to_json, :status => 200
    else
      render :json => true.to_json, :status => 200
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_geography
    @geography = Geography.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def geography_params
    params.require(:geography).permit(:numerical_code, :first_level, :second_level, :third_level, :fourth_level, :fifth_level, :description, :depth_detail, :state)
  end

  #
  def set_country
    country_id = session['country_id'].present? ? session['country_id'] : current_user.geography_id
    if country_id.to_i > 1
      @country = Geography.find(country_id)
    end
  end

  # Custom query, select level by country
  def selection_of_levels_by_country(country_code)
    sql_raw = "SELECT a.id, a.description, b.id, b.description, c.id, c.description, d.id, d.description, e.id, e.description
      FROM geographies a
        LEFT JOIN geographies b ON (a.first_level = b.first_level
          AND b.second_level != '0' AND b.third_level = '0')
        LEFT JOIN geographies c ON (a.first_level = c.first_level AND b.second_level = c.second_level
          AND c.second_level != '0' AND c.third_level != '0' AND c.fourth_level = '0')
        LEFT JOIN geographies d ON (a.first_level = d.first_level AND b.second_level = d.second_level AND c.third_level = d.third_level
          AND d.second_level != '0' AND d.third_level != '0' AND d.fourth_level != '0' AND d.fifth_level = '0')
        LEFT JOIN geographies e ON (a.first_level = e.first_level AND b.second_level = e.second_level AND c.third_level = e.third_level
          AND d.fourth_level = e.fourth_level AND e.second_level != '0' AND e.third_level != '0' AND e.fourth_level != '0'
          AND e.fifth_level != '0')
      WHERE a.second_level = '0' AND a.first_level = '#{country_code}'"
    return ActiveRecord::Base.connection.execute(sql_raw)
  end
end
