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

    get appointment_url(appointment.id), params: { 
      appointment: {
        id: appointment.id
      }
    }

    assert_response :success

    body = JSON.parse(response.body)
    assert_equal appointment.id, body['appointment']['id']
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