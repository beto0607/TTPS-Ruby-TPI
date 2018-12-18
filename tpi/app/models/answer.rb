class QuestionSolved < StandardError;end;
class AnswerSolution < StandardError;end;

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :content, :user_id, presence: true

  after_validation do |answer|
    #testing propurse
    if(Question.find_by(id:answer.question_id))then
      if(Question.find_by(id:answer.question_id).status == true)then
        raise QuestionSolved
      end
      if(answer.id != nil && Question.find_by(id:answer.question_id).answer_id == answer.id)then
        raise AnswerSolution
      end
    end
  end
end
