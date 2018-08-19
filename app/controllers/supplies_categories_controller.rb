class SuppliesCategoriesController < ApplicationController
  before_action :set_supplies_category, only: [:show, :edit, :update, :destroy]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern, GeographiesConcern, LanguagesConcern, ValidationsConcern

  # GET /supplies_categories
  # GET /supplies_categories.json
  def index
    @supplies_categories = get_model_by_country_allowed(SuppliesCategory).idiom(get_current_idiom)
  end

  # GET /supplies_categories/1
  # GET /supplies_categories/1.json
  def show
  end

  # GET /supplies_categories/new
  def new
    @supplies_category = SuppliesCategory.new
    @supplies_category.code = next_code_simple_model(SuppliesCategory)
  end

  # GET /supplies_categories/1/edit
  def edit
  end

  # POST /supplies_categories
  # POST /supplies_categories.json
  def create
    @supplies_category = SuppliesCategory.new(supplies_category_params)

    respond_to do |format|
      if @supplies_category.save
        format.html { redirect_to new_supplies_category_url, notice: get_message_created(SuppliesCategory) }
        format.json { render :show, status: :created, location: @supplies_category }
      else
        format.html { render :new }
        format.json { render json: @supplies_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supplies_categories/1
  # PATCH/PUT /supplies_categories/1.json
  def update
    respond_to do |format|
      if @supplies_category.update(supplies_category_params)
        format.html { redirect_to supplies_categories_url, notice: get_message_updated(SuppliesCategory) }
        format.json { render :show, status: :ok, location: @supplies_category }
      else
        format.html { render :edit }
        format.json { render json: @supplies_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /supplies_categories/1
  # DELETE /supplies_categories/1.json
  def destroy
    @supplies_category.destroy
    respond_to do |format|
      format.html { redirect_to supplies_categories_url, notice: get_message_destroyed(SuppliesCategory) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_supplies_category
    @supplies_category = SuppliesCategory.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def supplies_category_params
    params.require(:supplies_category).permit(:code, :description, :definition, :geography_id, :language_id, :state)
  end
end
