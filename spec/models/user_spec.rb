require 'rails_helper'

describe User do

  let(:user) { create(:user) }

  context 'associations' do
    it { is_expected.to embed_many :images }
  end

  context "generate_auth_token" do
    it "token must not be empty" do
      expect(user.api_token).not_to be_empty
    end
  end

end