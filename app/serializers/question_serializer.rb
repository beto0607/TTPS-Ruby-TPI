
class QuestionSerializer < BaseSerializer
  attributes :id, :title, :description, :status, :created_at, :updated_at

  has_one :user, include_links: false 

  has_one :answer do 
    Answer.find(object.answer_id) unless !object.answer_id
  end

  has_many :answers do
    object.answers
  end
  attribute :description_short do
    object.description[0, 120] + (object.description.length > 120 ? "..." : "")
  end
  attribute :answers_counter do
    object.answers_counter
  end

  attribute :answer_id do
    object.answer_id
  end
end