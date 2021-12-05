require 'rails_helper'

RSpec.describe Room, type: :model do

  before :each do
    @organization = create(:organization)
  end

  context "#Create Method" do
    it "Validar numero de salas conforme disponiveis por organização" do
      4.times do create(:room, organization: @organization); end
      surplus_room = Room.new(name: "Sala excedente", organization_id: @organization.id).save
      expect(surplus_room).to eq(false)
    end

  end

  context "Validar presença de Nome" do
    subject { build(:room, name: "") }
    it { expect(subject).to be_invalid }
  end
end


