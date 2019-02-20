class QuestionResource < JSONAPI::Resource
    attributes :title, :description,:description_short, :user_id, :status, :created_at, :updated_at, :answer_id, :answer_count
    has_one :user
    has_one :answer
    has_many :answers
end