class LanguagesController < ApplicationController
  before_action :set_language, only: [:show, :edit, :update, :destroy]

  # Load abilities for current user
  load_and_authorize_resource

  # Inclusions Concern
  include MessagesConcern

  # GET /languages
  # GET /languages.json
  def index
    @languages = Language.all
  end

  # GET /geographies/1
  # GET /geographies/1.json
  def show
  end

  # GET /languages/new
  def new
    @language = Language.new
  end

  # GET /languages/1/edit
  def edit
  end

  # POST /languages
  # POST /languages.json
  def create
    @language = Language.new(language_params)

    respond_to do |format|
      if @language.save
        format.html { redirect_to languages_url, notice: get_message_created(Language) }
        format.json { render :show, status: :created, location: @language }
      else
        format.html { render :new }
        format.json { render json: @language.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /languages/1
  # PATCH/PUT /languages/1.json
  def update
    respond_to do |format|
      if @language.update(language_params)
        format.html { redirect_to languages_url, notice: get_message_updated(Language) }
        format.json { render :show, status: :ok, location: @language }
      else
        format.html { render :edit }
        format.json { render json: @language.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /languages/1
  # DELETE /languages/1.json
  def destroy
    @language.state = false
    @language.save
    respond_to do |format|
      format.html { redirect_to languages_url, notice: get_message_destroyed(Language) }
      format.json { head :no_content }
    end
  end

  # GET /change_language/es
  def change_language
    selected_language = ''
    language = Language.find_by(abbreviation: params[:abbreviation])
    
    if language.present?
      session[:language_user] = language.abbreviation
      selected_language = session[:language_user]
    end

    respond_to do |format|
      format.json { render json: { language: selected_language } }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_language
    @language = Language.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def language_params
    params.require(:language).permit(:abbreviation, :name, :state)
  end
end
