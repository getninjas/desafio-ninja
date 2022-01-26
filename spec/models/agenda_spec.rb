require 'rails_helper'

RSpec.describe Agenda, type: :model do
  let(:name) { 'Agenda' }

  describe 'Relacionamentos' do
    it { is_expected.to belong_to(:sala) }
    it { is_expected.to have_many(:agendamentos) }
  end
end
