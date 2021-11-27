# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Meeting, type: :model do
  it { should belong_to(:room) }
  it { should validate_presence_of(:starts_at) }
  it { should validate_presence_of(:ends_at) }

  describe 'meeting datetime validation' do
    subject { build(:meeting, starts_at: start_date, ends_at: end_date) }

    describe 'about business hours' do
      context 'fails when meeting start is on weekend' do
        let(:start_date) { DateTime.new(2021, 11, 27, 10, 0, 0) }
        let(:end_date) { DateTime.new(2021, 11, 27, 12, 0, 0) }

        it { expect(subject).to be_invalid }
      end

      context 'fails when meeting end is on weekend' do
        let(:start_date) { DateTime.new(2021, 11, 28, 10, 0, 0) }
        let(:end_date) { DateTime.new(2021, 11, 28, 12, 0, 0) }

        it { expect(subject).to be_invalid }
      end

      context 'fails when meeting starts before 9AM' do
        let(:start_date) { DateTime.new(2021, 11, 25, 8, 0, 0) }
        let(:end_date) { DateTime.new(2021, 11, 25, 12, 0, 0) }

        it { expect(subject).to be_invalid }
      end

      context 'fails when meeting end after 6PM' do
        let(:start_date) { DateTime.new(2021, 11, 25, 19, 0, 0) }
        let(:end_date) { DateTime.new(2021, 11, 25, 20, 0, 0) }

        it { expect(subject).to be_invalid }
      end

      context 'success when a valid time is used' do
        let(:start_date) { DateTime.new(2021, 11, 25, 10, 0, 0) }
        let(:end_date) { DateTime.new(2021, 11, 25, 12, 0, 0) }

        it { expect(subject).to be_valid }
      end
    end

    context 'fails when a meeting has an invalid duration' do
      let(:start_date) { DateTime.new(2021, 11, 25, 12, 0, 0) }
      let(:end_date) { DateTime.new(2021, 11, 25, 10, 0, 0) }

      it { expect(subject).to be_invalid }
    end

    context 'when a room is occupied' do
      let(:room_one) { create(:room) }
      let(:room_two) { room_one }

      let!(:initial_meeting) { create(:meeting, starts_at: starts_at, ends_at: ends_at, room: room_one) }
      let(:starts_at) { DateTime.new(2021, 11, 25, 10, 0, 0) }
      let(:ends_at) { DateTime.new(2021, 11, 25, 12, 0, 0) }

      subject { build(:meeting, starts_at: start_date, ends_at: end_date, room: room_two) }

      context 'fails when starts_at is not available' do
        let(:start_date) { DateTime.new(2021, 11, 25, 11, 30, 0) }
        let(:end_date) { DateTime.new(2021, 11, 25, 13, 0, 0) }

        it { expect(subject).to be_invalid }
      end

      context 'fails when ends is not available' do
        let(:start_date) { DateTime.new(2021, 11, 25, 9, 30, 0) }
        let(:end_date) { DateTime.new(2021, 11, 25, 10, 30, 0) }

        it { expect(subject).to be_invalid }
      end

      context 'has success with meetings in different rooms' do
        let(:room_two) { create(:room) }

        let(:start_date) { DateTime.new(2021, 11, 25, 11, 30, 0) }
        let(:end_date) { DateTime.new(2021, 11, 25, 13, 0, 0) }

        it {
          expect(subject).to be_valid
        }
      end
    end
  end
end
