class SerializableUser < JSONAPI::Serializable::Resource
  type 'user'
  attributes :id, :email, :name
end