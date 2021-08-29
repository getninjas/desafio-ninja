require "rails_helper"

RSpec.describe ScheduleRoomsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/schedule_rooms").to route_to("schedule_rooms#index")
    end

    it "routes to #show" do
      expect(get: "/schedule_rooms/1").to route_to("schedule_rooms#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/schedule_rooms").to route_to("schedule_rooms#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/schedule_rooms/1").to route_to("schedule_rooms#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/schedule_rooms/1").to route_to("schedule_rooms#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/schedule_rooms/1").to route_to("schedule_rooms#destroy", id: "1")
    end
  end
end
