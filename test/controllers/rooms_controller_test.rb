require "test_helper"

class RoomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @room = rooms(:one)
  end

  test "should get index" do
    get rooms_url, as: :json
    assert_response :success
  end

  test "should create room" do
    assert_difference('Room.count') do
      post rooms_url, params: { room: { close_at: @room.close_at, name: @room.name, open_at: @room.open_at, people_limit_by_meeting: @room.people_limit_by_meeting, time_limit_by_meeting: @room.time_limit_by_meeting } }, as: :json
    end

    assert_response 201
  end

  test "should show room" do
    get room_url(@room), as: :json
    assert_response :success
  end

  test "should update room" do
    patch room_url(@room), params: { room: { close_at: @room.close_at, name: @room.name, open_at: @room.open_at, people_limit_by_meeting: @room.people_limit_by_meeting, time_limit_by_meeting: @room.time_limit_by_meeting } }, as: :json
    assert_response 200
  end

  test "should destroy room" do
    assert_difference('Room.count', -1) do
      delete room_url(@room), as: :json
    end

    assert_response 204
  end
end
