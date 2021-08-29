require "rails_helper"

RSpec.describe ScheduleRoom::ScheduleRoomController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/schedule_room").to route_to("schedule_room/schedule_room#index")
    end

    it "routes to #show" do
      expect(get: "/schedule_room/1").to route_to("schedule_room/schedule_room#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/schedule_room").to route_to("schedule_room/schedule_room#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/schedule_room/1").to route_to("schedule_room/schedule_room#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/schedule_room/1").to route_to("schedule_room/schedule_room#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/schedule_room/1").to route_to("schedule_room/schedule_room#destroy", id: "1")
    end
  end
end
