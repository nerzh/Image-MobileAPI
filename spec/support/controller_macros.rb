require 'rails_helper'

def json_response
  JSON.parse(response.body)
end

def login_user
    user = create(:user)
    request.env['HTTP_API_TOKEN'] = "Token #{user.api_token}"
    user
end

def login_user_with_images
  user = create(:user_with_images)
  request.env['HTTP_API_TOKEN'] = "Token #{user.api_token}"
  user
end
