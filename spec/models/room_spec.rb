# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  it { should validate_presence_of(:name) }

  it { should have_many(:meetings) }
end
