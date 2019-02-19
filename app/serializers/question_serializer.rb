# class QuestionSerializer < ActiveModel::Serializer
#   attributes :id, :title, :description, :status
#   has_one :user
# end


require 'jsonapi-serializers'

class QuestionSerializer
  include JSONAPI::Serializer
  
  attributes :id, :title, :description, :status

  has_one :user do
    object.user
  end
end