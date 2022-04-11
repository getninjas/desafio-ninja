# frozen_string_literal: true

require 'rails_helper'

describe Form::ScheduleForm do
  subject do
    described_class.new(attributes)
  end

  let(:attributes) do
    {
      id: id,
      title: title,
      date: date,
      start_hour: start_hour,
      end_hour: end_hour,
      room_id: room_id
    }
  end

  let(:id)         { nil }
  let(:title)      { "doesn't matter" }
  let(:date)       { "01/01/2022" }
  let(:start_hour) { 1 }
  let(:end_hour)   { 2 }
  let(:room_id)    { create(:room).id }

  describe "#validations" do
    it { validate_presence_of(:title) }
    it { validate_presence_of(:date) }
    it { validate_presence_of(:start_hour) }
    it { validate_presence_of(:end_hour) }
    it { validate_presence_of(:room_id) }

    describe "#check_start_end" do
      let(:start_hour) { 2 }

      it 'return end_hour_invalid' do
        subject.send(:check_start_end)
        expect(subject.errors.errors.last.type).to eq(:end_hour_invalid)
      end
    end
  end

  context "when id doesn't exists" do
    it 'create schedule' do
      subject.register
      expect(Schedule.last.title).to eq(title)
    end
  end

  context "when schedule exists" do
    let!(:schedule) { create(:schedule) }
    let(:id)        { schedule.id }
    let(:title)     { 'title test' }

    it 'update schedule' do
      subject.register
      expect(schedule.reload.title).to eq(title)
    end
  end
end
