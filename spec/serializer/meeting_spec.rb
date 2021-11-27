require 'rails_helper'

RSpec.describe MeetingSerializer, type: :serializer do
  describe "#attributes" do
    let(:meeting) { create(:meeting)}
    
    subject { described_class.new(meeting) }

    context 'returns attributes' do
      it 'with expected keys' do
        expect(subject.attributes.keys).to contain_exactly(:id, :title, :start_date, :end_date)
      end
    end
  end
end