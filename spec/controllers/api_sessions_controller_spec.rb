require 'rails_helper'

describe Api::SessionsController do

  context 'POST #login' do

    before(:each) do
      @user = create(:user)
      @user.update!(api_token: '')
    end

    it "response status 201" do
      post :login, user: { email: 'email@gmail.com', password: 'password' }
      expect(response.status).to eq(201)
    end

    it "check email in json" do
      post :login, user: { email: 'email@gmail.com', password: 'password' }
      expect(json_response["email"]).to eq(@user.email)
    end

    it "check token in json" do
      post :login, user: { email: 'email@gmail.com', password: 'password' }
      @user = User.find_by(email: 'email@gmail.com')
      expect(json_response["api_token"]).to eq(@user.api_token)
    end

    it "check token in response" do
      post :login, user: { email: 'email@gmail.com', password: 'password' }
      expect(response['HTTP_API_TOKEN']).to match(/^Token\s+[-\w]+$/)
    end

    it "number status error" do
      post :login, { email: 'email@gmail.com', password: 'pass' }
      expect(response.status).to eq(401)
    end

    it "response status error" do
      post :login, user: { email: '', password: 'password' }
      expect(response['APP_ERROR']).not_to be_empty
    end

    it "check error in json" do
      post :login, user: { email: 'email@gmail.com' }
      expect(json_response["error"]).not_to be_empty
    end
  end


  context 'DELETE #logout' do

    before(:each) do
      @user = login_user
    end

    it "response status 201" do
      delete :logout
      expect(response.status).to eq(200)
    end

    it "check token in response" do
      delete :logout
      expect(response['HTTP_API_TOKEN']).to eq('')
    end

  end



end