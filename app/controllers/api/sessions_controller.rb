class Api::SessionsController < Api::BaseController

  skip_before_action :verify_access?, only: [:login]

  def login
    user = User.find_by(email: session_params[:email])
    raise 'password is not valid' unless user.valid_password?(session_params[:password])
    user.send :generate_auth_token; user.update!
    send_response_with_token(201, user.api_token, json: user)
  rescue => ex
    send_error_response(401, ex, json: {error: ex.message})
  end


  def logout
    current_user.update!(api_token: "")
    send_response_with_token(200, '', nothing: true)
  rescue StandardError => ex
    send_error_response(501, ex, json: {error: ex.message})
  end

  private


  def session_params
    params.require(:user).permit(:email, :password, :api_token)
  end

end