require 'rails_helper'

RSpec.describe Schedule, type: :model do
  it { is_expected.to validate_presence_of(:scheduled_by) }
  it { is_expected.to validate_presence_of(:start_at) }
  it { is_expected.to validate_presence_of(:end_at) }
  it { is_expected.to belong_to(:room) }
end
