require 'rails_helper'

RSpec.describe Agendamento, type: :model do
  let(:resource) { build(:agendamento) }

  subject { resource }

  let(:name) { 'Sala' }

  describe 'Relacionamentos' do
    it { is_expected.to belong_to(:agenda) }
  end
end
