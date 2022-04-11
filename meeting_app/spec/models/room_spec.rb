# frozen_string_literal: true

require 'rails_helper'

describe Room do
  describe "#validations" do
    it { validate_presence_of(:name) }
    it { validate_uniqueness_of(:name) }
  end
end
