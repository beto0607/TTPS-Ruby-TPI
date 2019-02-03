class QuestionResource < JSONAPI::Resource
    attributes :title, :description,:description_short, :user_id, :status, :created_at, :updated_at, :answer_id, :answer_count
    has_one :user
    has_one :answer
    has_many :answers

    def description_short
        @model.description[0, 120] + (@model.description.length > 120 ? "..." : "")
    end
    def answer_count
        @model.answers.count
    end
end