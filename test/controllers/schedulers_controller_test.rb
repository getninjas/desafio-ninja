require "test_helper"

class SchedulersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @room = rooms(:one)
    @scheduler = schedulers(:one)
    @employee1 = employees(:one)
    @employee2 = employees(:two)
  end

  test "should get index" do
    get schedulers_url, as: :json
    assert_response :success
  end

  test "should create scheduler" do
    assert_difference('Scheduler.count') do
      post schedulers_url, params: { scheduler: { end_meeting_time: @scheduler.end_meeting_time, meeting_description: @scheduler.meeting_description, start_meeting_time: @scheduler.start_meeting_time, room_id: @room.id, employees_ids: [@employee1.id, @employee2.id] } }, as: :json
    end

    assert_response 201
  end

  test "should show scheduler" do
    get scheduler_url(@scheduler), as: :json
    assert_response :success
  end

  test "should update scheduler" do
    patch scheduler_url(@scheduler), params: { scheduler: { meeting_description: @scheduler.meeting_description, employees_ids: [@employee1.id, @employee2.id], room_id: @room.id } }, as: :json
    assert_response 200
  end

  test "should destroy scheduler" do
    assert_difference('Scheduler.count', 0) do #cant delete because already started
      delete scheduler_url(@scheduler), as: :json
    end

    assert_response 422
  end
end
