class SerializableRoom < JSONAPI::Serializable::Resource
  type 'room'
  attributes :id, :number, :description
end