class IncomesController < ApplicationController
  before_action :set_income, only: [:show, :edit, :update, :destroy]

  # GET /incomes
  # GET /incomes.json
  def index
    cost_center = IncomeDefinition.select(:cost_center_id).for_entity(session[:entity_id]).invoice
    @cost_centers = CostCenter.where(id: cost_center).order_priority.order(:code)
    @incomes = Income.date(session[:year], session[:month]).for_entity(session[:entity_id])
  end

  def save_incomes
    incomes = Income.find_or_initialize_by(year: params[:year], month: params[:month],
                                           entity_id: session[:entity_id], cost_center_id: params[:cost_center])
    incomes.year = params[:year]
    incomes.month = params[:month]
    incomes.entity_id = session[:entity_id]
    incomes.cost_center_id = params[:cost_center]
    incomes.value = params[:value]
    if not incomes.save
      return render :json => distribution_area.errors.to_json, :status => 400
    end
    render :json => 'ok'.to_json, :status => 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_income
      @income = Income.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def income_params
      params.require(:income).permit(:year, :month, :value, :cost_center_id, :entity_id)
    end
end
