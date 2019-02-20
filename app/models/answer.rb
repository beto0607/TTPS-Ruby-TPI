class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question, counter_cache: :answers_counter


  validates :content, :user_id, presence: true

end
