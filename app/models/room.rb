class Room < ApplicationRecord
  has_many :meetings
  belongs_to :organization
  validates :name, presence: true

  def limit_reached?

    rooms_in_organization = Room.where(organization_id: organization_id)

    if rooms_in_organization.count >= self.organization.number_of_rooms
      errors.add(:name, "Limite máximo de salas cadastradas foi atingida")
      true
    else
      false
    end
  end
end
