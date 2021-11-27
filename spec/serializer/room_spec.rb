require 'rails_helper'

RSpec.describe RoomSerializer, type: :serializer do
  describe "#attributes" do
    let(:room) { create(:room)}
    
    subject { described_class.new(room) }

    context 'returns attributes' do
      it 'with expected keys' do
        expect(subject.attributes.keys).to contain_exactly(:id, :name, :created_date, :updated_date)
      end
    end
  end
end