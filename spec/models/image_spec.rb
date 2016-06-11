require 'rails_helper'

describe Image do

  context 'associations' do
    it { is_expected.to be_embedded_in :user }
    it { is_expected.to embed_many :resized_files }
  end

end