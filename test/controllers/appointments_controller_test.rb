require 'test_helper'
class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  test "should create appointment successfully" do
    room = create(:room)
    appointment_attributes = appointment_attributes(room.id)

    post appointments_url, params: { appointment: appointment_attributes }

    assert_response :success
    assert Appointment.where(appointment_attributes).exists?
  end

  test "should return error if try create appointment with invalid params" do
    appointment_attributes = appointment_attributes(nil)

    post appointments_url, params: { appointment: appointment_attributes }

    assert_response :bad_request
    assert_not Appointment.where(appointment_attributes).exists?
  end

  test "should successfully return appointment" do
    appointment = create(:appointment)

    get appointment_url(appointment.id)

    assert_response :success

    body = JSON.parse(response.body)
    assert_equal appointment.id, body['appointment']['id']
  end

  test "should successfully update appointment" do
    appointment = create(:appointment)
    new_time = appointment_default_start_time
    appointment_attributes = {
      responsible_name: 'another name',
      start_time: (new_time + 1.hour).utc.iso8601,
      end_time: (new_time + 2.hour).utc.iso8601
    }

    put appointment_url(appointment.id), params: { appointment: appointment_attributes }

    assert_response :success

    appointment.reload
    assert_equal appointment.responsible_name, appointment_attributes[:responsible_name]
    assert_equal appointment.start_time, appointment_attributes[:start_time]
    assert_equal appointment.end_time, appointment_attributes[:end_time]
  end

  test "should return error if try update appointment with invalid params" do
    appointment = create(:appointment)

    put appointment_url(appointment.id), params: { 
      appointment: {
        room_id: ''
      }
    }

    assert_response :bad_request

    assert_equal appointment, appointment.reload
  end

  test "should successfully destroy appointment" do
    appointment = create(:appointment)

    delete appointment_url(appointment.id)

    assert_response :success

    assert_not Appointment.where(id: appointment.id).exists?
  end

  private

  def appointment_attributes(room_id)
    attributes = build(:appointment).attributes
                                    .select { |k, v| v.present? }
                                    .with_indifferent_access

    attributes[:room_id] = room_id
    attributes[:start_time] = attributes[:start_time].utc.iso8601
    attributes[:end_time] = attributes[:end_time].utc.iso8601

    attributes
  end
end