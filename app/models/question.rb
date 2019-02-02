class Question < ApplicationRecord
  belongs_to :user
  
  has_one :answers, as: :answer_id, required: false, dependent: :restrict_with_exception #Answer tagged as solution

  has_many :answers, dependent: :restrict_with_exception 

  validates :title, presence: true
  validates :description, presence: true

  def self.pageSize
    50
  end
end
