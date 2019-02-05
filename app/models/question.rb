class Question < ApplicationRecord
  belongs_to :user
  
  has_one :answers, required: false, dependent: :restrict_with_exception  #Answer tagged as solution

  has_many :answers, dependent: :restrict_with_exception 

  validates :title, presence: true
  validates :description, presence: true

  before_create :set_status_to_false


  def self.pageSize
    50
  end
  private
  def set_status_to_false
    self.status = false
    self.answer_id = nil
  end
end
