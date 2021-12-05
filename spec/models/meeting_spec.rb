require 'rails_helper'

RSpec.describe Meeting, type: :model do
  
  before :all do
    @room_1 = create(:room)
  end

  context "Validações de datas" do 

    subject { build(:meeting, starts_at: start_date, end_at: end_date, room: @room_1) }

    context "Validar presença de Inicio" do
      let(:start_date) { "" }
      let(:end_date) { "06/12/2021 19:00" }
      it { expect(subject).to be_invalid }
    end

    context "Validar presença de fim" do
      let(:start_date) { "06/12/2021 19:00" }
      let(:end_date) { "" }
      it { expect(subject).to be_invalid }
    end

    context "Data de inicio deve ser maior que data final" do
      let(:start_date) { "06/12/2021 12:00" }
      let(:end_date) { "06/12/2021 11:00" }
      it { expect(subject).to be_invalid }
    end

    context "Datas devem ser em dias úteis" do
      let(:start_date) { "05/12/2021 10:00" }
      let(:end_date) { "05/12/2021 11:00" }
      it { expect(subject).to be_invalid }
    end

    context "Inicio deve ser após começo de horário comercial" do
      let(:start_date) { "06/12/2021 08:00" }
      let(:end_date) { "06/12/2021 19:00" }
      it { expect(subject).to be_invalid }
    end

    context "Inicio deve ser antes do fim de horário comercial" do
      let(:start_date) { "06/12/2021 17:00" }
      let(:end_date) { "06/12/2021 19:00" }
      it { expect(subject).to be_invalid }
    end
  end

  context "Validação de regras de agendamento" do

    let!(:meeting_1) {create(:meeting, starts_at: "06/12/2021 09:00", end_at: "06/12/2021 10:00", room: @room_1)}
    subject { build(:meeting, starts_at: start_date, end_at: end_date, room: @room_1) }
    
    context "Sala já reservada" do  
      let(:start_date) { "06/12/2021 09:00" }
      let(:end_date) { "06/12/2021 11:00" }
      it { expect(subject).to be_invalid }
    end
  end
end
