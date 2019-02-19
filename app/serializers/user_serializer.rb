# class UserSerializer < ActiveModel::Serializer
#   attributes :id, :email, :username, :screen_name
# end



require 'jsonapi-serializers'

class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :username, :screen_name

  
  def self_link
    nil
  end
  
end
