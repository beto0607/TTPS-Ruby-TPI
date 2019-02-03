class AnswerResource < JSONAPI::Resource
    attributes :user_id, :question_id, :content
    has_one :user
    has_one :question

    filter :question

end
