class CostDistributionsController < ApplicationController
  before_action :set_cost_distribution, only: [:show, :edit, :update, :destroy]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern, GeographiesConcern, LanguagesConcern, ValidationsConcern

  # GET /cost_distributions
  # GET /cost_distributions.json
  def index
    @cost_distributions = get_model_by_country_allowed(CostDistribution).idiom(get_current_idiom)
  end

  # GET /cost_distributions/1
  # GET /cost_distributions/1.json
  def show
  end

  # GET /cost_distributions/new
  def new
    @cost_distribution = CostDistribution.new
    @cost_distribution.code = next_code_simple_model(CostDistribution)
  end

  # GET /cost_distributions/1/edit
  def edit
  end

  # POST /cost_distributions
  # POST /cost_distributions.json
  def create
    @cost_distribution = CostDistribution.new(cost_distribution_params)

    respond_to do |format|
      if @cost_distribution.save
        format.html { redirect_to new_cost_distribution_url, notice: get_message_created(CostDistribution) }
        format.json { render :show, status: :created, location: @cost_distribution }
      else
        format.html { render :new }
        format.json { render json: @cost_distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cost_distributions/1
  # PATCH/PUT /cost_distributions/1.json
  def update
    respond_to do |format|
      if @cost_distribution.update(cost_distribution_params)
        format.html { redirect_to cost_distributions_url, notice: get_message_updated(CostDistribution) }
        format.json { render :show, status: :ok, location: @cost_distribution }
      else
        format.html { render :edit }
        format.json { render json: @cost_distribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cost_distributions/1
  # DELETE /cost_distributions/1.json
  def destroy
    @cost_distribution.destroy
    respond_to do |format|
      format.html { redirect_to cost_distributions_url, notice: get_message_destroyed(CostDistribution) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cost_distribution
      @cost_distribution = CostDistribution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cost_distribution_params
      params.require(:cost_distribution).permit(:code, :description, :definition, :geography_id, :language_id, :state)
    end
end
