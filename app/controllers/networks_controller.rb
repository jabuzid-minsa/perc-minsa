class NetworksController < ApplicationController
  before_action :set_network, only: [:show, :edit, :update, :destroy]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern, GeographiesConcern

  # GET /networks
  # GET /networks.json
  def index
    @networks = Network.active.available_for_country(get_country_valid_by_user('numerical_code'))
  end

  # GET /networks/1
  # GET /networks/1.json
  def show
  end

  # GET /networks/new
  def new
    @network = Network.new
  end

  # GET /networks/1/edit
  def edit
  end

  # POST /networks
  # POST /networks.json
  def create
    @network = Network.new(network_params)

    respond_to do |format|
      if @network.save
        format.html { redirect_to new_network_path, notice: get_message_created(Network) }
        format.json { render :show, status: :created, location: @network }
      else
        format.html { render :new }
        format.json { render json: @network.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /networks/1
  # PATCH/PUT /networks/1.json
  def update
    respond_to do |format|
      if @network.update(network_params)
        format.html { redirect_to networks_path, notice: get_message_updated(Network) }
        format.json { render :show, status: :ok, location: @network }
      else
        format.html { render :edit }
        format.json { render json: @network.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /networks/1
  # DELETE /networks/1.json
  def destroy
    @network.destroy
    respond_to do |format|
      format.html { redirect_to networks_url, notice: get_message_destroyed(Network) }
      format.json { head :no_content }
    end
  end

  def get_network_for_country
    networks = Network.active.available_for_country(params[:numerical_code])
    render :json => networks.to_json, :status => 200
  end

  # Change between the different entities created
  def change_network
    session[:network_id] = params[:network_id].present? ? params[:network_id] : 0
    session[:entity_id] = ''
    entities = Entity.active.for_networks(session[:network_id])
    render :json => [entities, t('change_network')].to_json, :status => 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_network
      @network = Network.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def network_params
      params.require(:network).permit(:code, :description, :geography_id, :state, :entity_ids => [])
    end
end
