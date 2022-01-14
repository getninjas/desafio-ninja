require "rails_helper"

RSpec.describe SchedulingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/schedulings").to route_to("schedulings#index")
    end

    it "routes to #show" do
      expect(get: "/schedulings/1").to route_to("schedulings#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/schedulings").to route_to("schedulings#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/schedulings/1").to route_to("schedulings#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/schedulings/1").to route_to("schedulings#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/schedulings/1").to route_to("schedulings#destroy", id: "1")
    end
  end
end
