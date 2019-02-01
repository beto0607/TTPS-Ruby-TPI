class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :username, :screen_name
end
