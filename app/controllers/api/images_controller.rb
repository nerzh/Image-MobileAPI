class Api::ImagesController < Api::BaseController

  def index
    render json: Image.get_images(permit_parameters, current_user), status: 200
  rescue => ex
    send_error_response(501, ex, nothing: true)
  end

  def new_image
    render json: Image.new_image(permit_parameters, current_user), status: 201
  rescue => ex
    send_error_response(501, ex, nothing: true)
  end

  def old_image
    render json: Image.old_image(permit_parameters, current_user), status: 201
  rescue => ex
    send_error_response(501, ex, nothing: true)
  end

  private

  def permit_parameters
    params.permit(:id, :file, :size)
  end

end