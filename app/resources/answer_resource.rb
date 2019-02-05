class AnswerResource < JSONAPI::Resource
    attributes :user_id, :question_id, :content
    has_one :user
    has_one :question
    def custom_links(options)
        { 
            question: options[:serializer].link_builder.base_url + "/questions/#{self.question_id}",
            self: nil
        }
    end
end
