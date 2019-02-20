class Question < ApplicationRecord
  belongs_to :user
  
  has_one :answers, required: false, dependent: :restrict_with_exception  #Answer tagged as solution

  has_many :answers, dependent: :restrict_with_exception 

  validates :title, presence: true
  validates :description, presence: true

  before_create :set_status_to_false


  scope :needing_help,  -> { where(status: false).order("answers_counter DESC, created_at DESC") }
  scope :pending_first, -> { order('status ASC, created_at DESC') }
  scope :latest,        -> { order('created_at DESC') }
  scope :questionsLimit,         -> { limit(50) }

  private
  def set_status_to_false
    self.status = false
    self.answer_id = nil
  end
end
