class Organization < ApplicationRecord
  has_many :rooms

  validates :name, :number_of_rooms, :business_hours_start, :business_hours_end, presence: true

  # validate :validate_business_start
  # validate :validate_business_end

  def validate_business_start
    hour_start = self.business_hours_start.scan(/\A(?!00:00)[0-2][0-3]:[0-5][0-9]\Z/)
    if hour_start.empty?
      self.errors.add(:business_hours_start, self.business_hours_start)
    else
      true
    end
  end

  def validate_business_end
    hour_end = self.business_hours_end.scan(/\A(?!00:00)[0-2][0-3]:[0-5][0-9]\Z/)
    if hour_end.empty?
      self.errors.add(:business_hours_end, self.business_hours_end)
    else
      true
    end
  end

end
