require 'rails_helper'

describe ResizedFile do

  context 'associations' do
    it { is_expected.to be_embedded_in :image }
  end

end