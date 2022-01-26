require 'rails_helper'

RSpec.describe Sala, type: :model do
  let(:name) { 'Sala' }

  describe 'Relacionamentos' do
    it { is_expected.to have_one(:agenda) }
  end
end
