require 'rails_helper'

describe Api::UsersController do

  context 'POST #create' do

    it "response status 201" do
      post :create, user: { email: 'email@gmail.com', password: '12345678' }
      expect(response.status).to eq(201)
    end

    it "check email in json" do
      post :create, user: { email: 'email@gmail.com', password: '12345678' }
      expect(json_response["email"]).to eq('email@gmail.com')
    end

    it "check token in json" do
      post :create, user: { email: 'email@gmail.com', password: '12345678' }
      expect(json_response["api_token"]).not_to be_empty
    end

    it "check token in response" do
      post :create, user: { email: 'email@gmail.com', password: '12345678' }
      expect(response['HTTP_API_TOKEN']).to match(/^Token\s+[-\w]+$/)
    end

    it "number status error" do
      post :create, { email: 'email@gmail.com', password: '12345678' }
      expect(response.status).to eq(501)
    end

    it "response status error" do
      post :create, user: { email: '', password: '12345678' }
      expect(response['APP_ERROR']).not_to be_empty
    end

    it "check error in json" do
      post :create, user: { email: 'email@gmail.com' }
      expect(json_response["error"]).not_to be_empty
    end
  end

  context 'PATCH #update' do

    before(:each) do
      @user = login_user
    end

    it "response status 200" do
      patch :update, user: { email: 'email2@gmail.com', password: '1234567890', api_token: @user.api_token }
      expect(response.status).to eq(200)
    end

    it "check email" do
      patch :update, user: { email: 'email2@gmail.com', password: '1234567890', api_token: @user.api_token }
      user2 = User.find_by(api_token: @user.api_token)
      expect(@user.email).not_to eq(user2.email)
    end

    it "check email in json" do
      post :create, user: { email: 'email2@gmail.com', password: '1234567890', api_token: @user.api_token }
      expect(json_response["email"]).to eq('email2@gmail.com')
    end

    it "check token in json" do
      patch :update, user: { email: 'email2@gmail.com', password: '1234567890', api_token: @user.api_token }
      expect(json_response["api_token"]).to eq(@user.api_token)
    end

    it "token must not be changed" do
      patch :update, user: { email: 'email2@gmail.com', password: '1234567890', api_token: @user.api_token }
      user2 = User.all.first
      expect(user2.api_token).to eq(@user.api_token)
    end

    it "check token in response" do
      patch :update, user: { email: 'email2@gmail.com', password: '1234567890', api_token: @user.api_token }
      expect(response['HTTP_API_TOKEN']).to match(/^Token\s+[-\w]+$/)
    end

    it "number status error" do
      patch :update, { email: 'email2@gmail.com', password: '123456789' }
      expect(response.status).to eq(501)
    end

    it "response status error" do
      patch :update, { email: 'email2@gmail.com', password: '123456789' }
      expect(response['APP_ERROR']).not_to be_empty
    end

    it "check error in json" do
      patch :update, { email: 'email2@gmail.com', password: '123456789' }
      expect(json_response["error"]).not_to be_empty
    end
  end

  context 'DELETE #delete' do

    before(:each) do
      @user = login_user
    end

    it "response status 200" do
      delete :delete, user: { api_token: @user.api_token }
      expect(response.status).to eq(410)
    end

    it "check user" do
      delete :delete, user: { api_token: @user.api_token }
      user2 = User.where(api_token: @user.api_token).first
      expect(user2).to eq(nil)
    end

    it "check email in json" do
      delete :delete, user: { api_token: @user.api_token }
      expect(json_response["email"]).to eq(@user.email)
    end

    it "check token in json" do
      delete :delete, user: { email: 'email2@gmail.com', password: '1234567890', api_token: @user.api_token }
      expect(json_response["api_token"]).to eq(@user.api_token)
    end

    it "check token in response" do
      delete :delete, user: { email: 'email@gmail.com', password: '12345678', api_token: @user.api_token }
      expect(response['HTTP_API_TOKEN']).to match(/^Token\s+[-\w]+$/)
    end

    it "number status error" do
      delete :delete, { email: 'email@gmail.com', password: '12345678' }
      expect(response.status).to eq(501)
    end

    it "response status error" do
      delete :delete, { email: 'email@gmail.com', password: '12345678' }
      expect(response['APP_ERROR']).not_to be_empty
    end

    it "check error in json" do
      delete :delete, { email: 'email@gmail.com', password: '12345678' }
      expect(json_response["error"]).not_to be_empty
    end
  end

end