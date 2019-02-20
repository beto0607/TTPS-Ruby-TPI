class AnswerSerializer < BaseSerializer
  attributes :id, :content, :question_id, :created_at, :updated_at
  has_one :user
  has_one :question


  def self_link
    "#{base_url}/questions/#{object.question_id}/#{type}/#{id}"
  end
end
