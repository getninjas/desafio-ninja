require 'rails_helper'

RSpec.describe Organization, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:number_of_rooms) }
  it { should validate_presence_of(:business_hours_start) }
  it { should validate_presence_of(:business_hours_end) }
end
