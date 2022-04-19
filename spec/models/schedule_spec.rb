require 'rails_helper'

RSpec.describe Schedule, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
    it { should belong_to(:user) }
    it { should belong_to(:room) }

    it 'must not create with start time greater than end time' do
      room = create(:room)
      user = create(:user)
      datetime = DateTime.current
      schedule = Schedule.create(
        room_id: room.id,
        user_id: user.id,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 17, 0, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 16, 0, 0),
        duration: 1
      )

      expect(schedule.persisted?).to_not be_truthy
    end

    it 'should not create with start date on saturday' do
      datetime = DateTime.current
      index = 1
      while !datetime.saturday?
        datetime = DateTime.current + index.day
        index = index.next
      end

      room = create(:room)
      user = create(:user)
      schedule = Schedule.create(
        room_id: room.id,
        user_id: user.id,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 16, 0, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 17, 0, 0),
        duration: 1
      )

      expect(schedule.persisted?).to_not be_truthy
    end

    it 'must not create with start date on Sunday' do
      datetime = DateTime.current
      index = 1
      while !datetime.sunday?
        datetime = DateTime.current + index.day
        index = index.next
      end

      room = create(:room)
      user = create(:user)
      schedule = Schedule.create(
        room_id: room.id,
        user_id: user.id,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 16, 0, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 17, 0, 0),
        duration: 1
      )

      expect(schedule.persisted?).to_not be_truthy
    end

    it 'must not create with time less than 9' do
      datetime = DateTime.current
      room = create(:room)
      user = create(:user)
      schedule = Schedule.create(
        room_id: room.id,
        user_id: user.id,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 8, 0, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 17, 0, 0),
        duration: 1
      )

      expect(schedule.persisted?).to_not be_truthy
    end

    it 'must not create with time greater than 18' do
      datetime = DateTime.current
      room = create(:room)
      user = create(:user)
      schedule = Schedule.create(
        room_id: room.id,
        user_id: user.id,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 19, 0, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 20, 0, 0),
        duration: 1
      )

      expect(schedule.persisted?).to_not be_truthy
    end

    it 'should not create with with interval greater than 1 day' do
      datetime = DateTime.current
      room = create(:room)
      user = create(:user)
      schedule = Schedule.create(
        room_id: room.id,
        user_id: user.id,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 17, 0, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day + 1, 18, 0, 0),
        duration: 1
      )

      expect(schedule.persisted?).to_not be_truthy
    end

    it 'must not create at the same time as another reserve, first possibility' do
      datetime = DateTime.current
      room = create(:room)
      user = create(:user)
      create(
        :schedule,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 9, 0, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 10, 0, 0),
        room_id: room.id,
        duration: 1,
        user_id: create(:user).id
      )

      create(
        :schedule,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 11, 0, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 12, 0, 0),
        room: room,
        user: create(:user)
      )

      schedule = Schedule.create(
        room_id: room.id,
        user_id: user.id,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 11, 30, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 12, 30, 0),
        duration: 1
      )

      expect(schedule.persisted?).to_not be_truthy
    end

    it 'should not create if the time is earlier than now' do
      datetime = DateTime.current - 1.day
      room = create(:room)
      user = create(:user)

      schedule = Schedule.create(
        room_id: room.id,
        user_id: user.id,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 11, 30, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 12, 30, 0),
        duration: 1
      )

      expect(schedule.persisted?).to_not be_truthy
    end

    it 'must not create at the same time as another reserve, second possibility' do
      datetime = DateTime.current
      room = create(:room)
      user = create(:user)
      create(
        :schedule,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 9, 0, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 10, 0, 0),
        room_id: room.id,
        duration: 1,
        user_id: create(:user).id
      )

      create(
        :schedule,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 13, 0, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 14, 0, 0),
        room: room,
        user: create(:user)
      )

      schedule = Schedule.create(
        room_id: room.id,
        user_id: user.id,
        start_time: DateTime.new(datetime.year, datetime.month, datetime.day, 12, 30, 0),
        end_time: DateTime.new(datetime.year, datetime.month, datetime.day, 13, 30, 0),
        duration: 1
      )

      expect(schedule.persisted?).to_not be_truthy
    end
  end
end
