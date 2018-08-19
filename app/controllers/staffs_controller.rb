class StaffsController < ApplicationController
  before_action :set_staff, only: [:show, :edit, :update, :destroy]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern, GeographiesConcern, LanguagesConcern, ValidationsConcern

  # GET /staffs
  # GET /staffs.json
  def index
    @staffs = get_model_by_country_allowed(Staff).idiom(get_current_idiom)
  end

  # GET /staffs/1
  # GET /staffs/1.json
  def show
  end

  # GET /staffs/new
  def new
    @staff = Staff.new
    @staff.code = next_code_model(Staff, 'staff_id', nil).to_s.rjust(5, '0')
  end

  # GET /staffs/1/edit
  def edit
  end

  # POST /staffs
  # POST /staffs.json
  def create
    @staff = Staff.new(staff_params)

    respond_to do |format|
      if @staff.save
        format.html { redirect_to new_staff_url, notice: get_message_created(Staff) }
        format.json { render :show, status: :created, location: @staff }
      else
        format.html { render :new }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staffs/1
  # PATCH/PUT /staffs/1.json
  def update
    respond_to do |format|
      if @staff.update(staff_params)
        format.html { redirect_to staffs_url, notice: get_message_updated(Staff) }
        format.json { render :show, status: :ok, location: @staff }
      else
        format.html { render :edit }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staffs/1
  # DELETE /staffs/1.json
  def destroy
    @staff.destroy
    respond_to do |format|
      format.html { redirect_to staffs_url, notice: get_message_destroyed(Staff) }
      format.json { head :no_content }
    end
  end

  def ajax_next_code
    staff_id = params[:staff] == '' ? nil : params[:staff]
    code = next_code_model(Staff, 'staff_id', staff_id)
    render :json => code.to_s.rjust(5, '0').to_json, :status => 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff
      @staff = Staff.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staff_params
      params.require(:staff).permit(:code, :description, :definition, :staff_id, :geography_id, :language_id, :state)
    end
end
