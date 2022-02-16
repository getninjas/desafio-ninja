require "test_helper"

class SchedulersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scheduler = schedulers(:one)
  end

  test "should get index" do
    get schedulers_url, as: :json
    assert_response :success
  end

  test "should create scheduler" do
    assert_difference('Scheduler.count') do
      post schedulers_url, params: { scheduler: { end_meeting_time: @scheduler.end_meeting_time, meeting_description: @scheduler.meeting_description, start_meeting_time: @scheduler.start_meeting_time } }, as: :json
    end

    assert_response 201
  end

  test "should show scheduler" do
    get scheduler_url(@scheduler), as: :json
    assert_response :success
  end

  test "should update scheduler" do
    patch scheduler_url(@scheduler), params: { scheduler: { end_meeting_time: @scheduler.end_meeting_time, meeting_description: @scheduler.meeting_description, start_meeting_time: @scheduler.start_meeting_time } }, as: :json
    assert_response 200
  end

  test "should destroy scheduler" do
    assert_difference('Scheduler.count', -1) do
      delete scheduler_url(@scheduler), as: :json
    end

    assert_response 204
  end
end
