require 'test_helper'

class AppointmentTest < ActiveSupport::TestCase
  test 'room availability' do
    appointment = build(:appointment)
    reference_time = appointment.start_time.beginning_of_day

    # respect room limits
    assert appointment.valid?

    # Doesn't respect room limits to start fully
    appointment.start_time = reference_time + 8.hours
    appointment.end_time = reference_time + 9.hours + 30.minutes
    assert_not appointment.valid?

    # Doesn't respect room limits to start at all
    appointment.start_time = reference_time + 7.hours
    appointment.end_time = reference_time + 8.hours
    assert_not appointment.valid?


    # Doesn't respect room limits to end fully
    appointment.start_time = reference_time + 17.hours
    appointment.end_time = reference_time + 19.hours
    assert_not appointment.valid?

    # Doesn't respect room limits to end at all
    appointment.start_time = reference_time + 19.hours
    appointment.end_time = reference_time + 20.hours
    assert_not appointment.valid?

    # More than one day
    appointment.start_time = reference_time + 10.hours
    appointment.end_time = appointment.start_time + 1.day
    assert_not appointment.valid?
  end

  test 'time window disjunction' do
    appointment1 = create(:appointment)
    reference_time = appointment1.start_time.beginning_of_day

    # Exact time
    appointment2 = build(:appointment, room: appointment1.room)
    assert_not appointment2.valid?

    # A bit later
    appointment2.start_time = appointment2.start_time + 10.minutes
    assert_not appointment2.valid?

    # A bit earlier
    appointment2.start_time = appointment2.start_time - 20.minutes
    assert_not appointment2.valid?

    # Embracing existing appointment
    appointment2.end_time = appointment2.end_time + 10.minute
    assert_not appointment2.valid?

    # Doesn't intersect
    appointment2.start_time = reference_time + 12.hours
    appointment2.end_time = reference_time + 13.hours
    assert appointment2.valid?
  end

  test 'time interval' do
    appointment = build(:appointment)

    assert appointment.valid?

    appointment.end_time = appointment.start_time - 1.hour
    assert_not appointment.valid?
  end
end