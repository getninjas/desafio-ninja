require "rails_helper"

RSpec.describe Rooms::RoomsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/rooms").to route_to("rooms/rooms#index")
    end

    it "routes to #show" do
      expect(get: "/rooms/1").to route_to("rooms/rooms#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/rooms").to route_to("rooms/rooms#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/rooms/1").to route_to("rooms/rooms#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/rooms/1").to route_to("rooms/rooms#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/rooms/1").to route_to("rooms/rooms#destroy", id: "1")
    end
  end
end
