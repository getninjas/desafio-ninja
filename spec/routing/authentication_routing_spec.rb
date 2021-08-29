require "rails_helper"

RSpec.describe AuthenticationController, type: :routing do
  describe "routing" do
    it "routes to #authenticate" do
      expect(post: "/authenticate").to route_to("authentication#authenticate")
    end
  end
end
