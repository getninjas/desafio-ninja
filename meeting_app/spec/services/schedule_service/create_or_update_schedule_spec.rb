# frozen_string_literal: true

require 'rails_helper'

describe ScheduleService::CreateOrUpdateSchedule do
  subject do
    described_class.new(attributes, room, schedule)
  end

  let(:attributes) do
    {
      id: id,
      title: title,
      date: date,
      start_hour: start_hour,
      end_hour: end_hour,
    }
  end

  let(:room) { create(:room) }
  let(:schedule) { nil }

  let(:id)         { nil }
  let(:title)      { "doesn't matter" }
  let(:date)       { "01/01/2022" }
  let(:start_hour) { 1 }
  let(:end_hour)   { 2 }

  context "when has invalid params" do
    context 'when has no title' do
      let(:title) { nil }

      it { expect { subject.before }.to raise_exception(ExceptionService::InvalidParamsException) }
    end

    context 'when has no date' do
      let(:date) { nil }

      it { expect { subject.before }.to raise_exception(ExceptionService::InvalidParamsException) }
    end

    context 'when has no start_hour' do
      let(:start_hour) { nil }

      it { expect { subject.before }.to raise_exception(ExceptionService::InvalidParamsException) }
    end

    context 'when has no end_hour' do
      let(:end_hour) { nil }

      it { expect { subject.before }.to raise_exception(ExceptionService::InvalidParamsException) }
    end

    context 'when date is invalid' do
      let(:date) { "doesnt'matter" }

      it { expect { subject.before }.to raise_exception(ExceptionService::InvalidParamsException) }
    end
  end

  context "when start date is equal or bigger than end date" do
    subject { described_class.call(attributes, room, schedule) }

    let(:start_hour) { 2 }
    let(:end_hour)   { 1 }

    it { expect { subject }.to raise_exception(ExceptionService::ModelErrorException) }
  end

  context "when has already schedule already taken on that date and time" do
    subject { described_class.call(attributes, room, schedule) }

    let!(:schedule)  { create(:schedule, date: Date.today, start_hour: 1, end_hour: 2, room_id: room.id) }
    let(:date)       { Date.today }
    let(:start_hour) { 2 }
    let(:end_hour)   { 3 }

    it { expect { subject }.to raise_exception(ExceptionService::ScheduleAlreadyTakenException) }
  end

  context 'when schedule is created' do
    subject { described_class.call(attributes, room, schedule) }

    it 'create a schedule' do
      subject
      attrs = Schedule.last.attributes.slice(*%w[title date start_hour end_hour])
      attrs['date'] = attrs['date'].strftime('%d/%m/%Y')
      expect(attrs).to eq(attributes.except(:id).as_json)
    end
  end

  context 'when schedule is updated' do
    subject { described_class.call(attributes, room, schedule) }

    let(:another_schedule) { create(:schedule) }
    let(:id)               { another_schedule.id }
    let(:start_hour)       { 2 }
    let(:end_hour)         { 3 }
    let(:title)            { 'another title' }

    it 'create a schedule' do
      subject
      expect(another_schedule.reload.title).to eq(title)
    end
  end
end
