class SerializableSchedule < JSONAPI::Serializable::Resource
  type 'schedule'
  attributes :id, :start_time, :end_time

  belongs_to :room
  belongs_to :user
end