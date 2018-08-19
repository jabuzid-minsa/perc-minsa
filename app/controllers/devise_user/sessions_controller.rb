class DeviseUser::SessionsController < Devise::SessionsController

  # GET /resource/sign_in
  def new
    reset_session
    super
  end

  # POST /resource/sign_in
  def create
    super do |resource|
      unless resource.state?
        sign_out
        redirect_to new_user_session_path, notice: 'Su cuenta no esta activa'
        return
      end
      if resource.geography_id != 1
        session[:country_id] = resource.geography_id
      end
    end
  end

  # DELETE /resource/sign_out
  def destroy
    reset_session
    user = User.find(current_user.id)
    current_user.role = user.role
    super
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
