class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :content
  has_one :user
  has_one :question
end


require 'jsonapi-serializers'
