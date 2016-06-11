class Api::UsersController < Api::BaseController
  skip_before_action :verify_access?, only: [:create]

  def create
    user = User.new(user_params)
    user.save!
    send_response_with_token(201, user.api_token, json: user)
  rescue => ex
    send_error_response(501, ex, json: {error: ex.message})
  end

  def update
    user = User.find_by(api_token: user_params[:api_token])
    user.update!(user_params)
    render json: user, status: 200
  rescue => ex
    send_error_response(501, ex, json: {error: ex.message})
  end

  def delete
    user = User.find_by(api_token: user_params[:api_token])
    user.destroy!
    render json: user, status: 410
  rescue => ex
    send_error_response(501, ex, json: {error: ex.message})
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :api_token)
  end

end