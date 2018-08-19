class IncomeDefinitionsController < ApplicationController
  before_action :set_income_definition, only: [:show, :edit, :update, :destroy]

  # GET /income_definitions
  # GET /income_definitions.json
  def index
    @income_definitions = IncomeDefinition.where(entity_id: session[:entity_id])
  end

  # GET /income_definitions/1
  # GET /income_definitions/1.json
  def show
  end

  # GET /income_definitions/new
  def new
    @income_definition = IncomeDefinition.new
  end

  # GET /income_definitions/1/edit
  def edit
  end

  # POST /income_definitions
  # POST /income_definitions.json
  def create
    @income_definition = IncomeDefinition.new(income_definition_params)

    respond_to do |format|
      if @income_definition.save
        format.html { redirect_to @income_definition, notice: 'Income definition was successfully created.' }
        format.json { render :show, status: :created, location: @income_definition }
      else
        format.html { render :new }
        format.json { render json: @income_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /income_definitions/1
  # PATCH/PUT /income_definitions/1.json
  def update
    respond_to do |format|
      if @income_definition.update(income_definition_params)
        format.html { redirect_to @income_definition, notice: 'Income definition was successfully updated.' }
        format.json { render :show, status: :ok, location: @income_definition }
      else
        format.html { render :edit }
        format.json { render json: @income_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /income_definitions/1
  # DELETE /income_definitions/1.json
  def destroy
    @income_definition.destroy
    respond_to do |format|
      format.html { redirect_to income_definitions_url, notice: 'Income definition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_income_definition
      @income_definition = IncomeDefinition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def income_definition_params
      params.require(:income_definition).permit(:invoice, :cost_center_id, :entity_id)
    end
end
