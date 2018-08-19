class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern, GeographiesConcern, LanguagesConcern

  # GET /users
  # GET /users.json
  def index
    country_ids = []
    if current_user.is_valid_geography?
      country_ids << current_user.geography_id
    elsif current_user.is_valid_session_country?(session[:country_id])
      country_ids << session[:country_id]
    end
    if current_user.is_global_administrator?
      @users = User.where.not(id: current_user.id)
    else
      @users = User.where(geography_id: country_ids).where.not(id: current_user.id)
    end
  end

  # GET /supplies_categories/1/edit
  def edit
  end

  # PATCH/PUT /supplies_categories/1
  # PATCH/PUT /supplies_categories/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: get_message_updated(User) }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email, :full_name, :geography_id, :role, :state, :entity_ids => [], :network_ids => [])
  end

end
