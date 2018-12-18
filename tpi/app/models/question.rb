class Question < ApplicationRecord
  belongs_to :user

  has_one :answer, dependent: :restrict_with_exception
  
  has_many :answers, dependent: :restrict_with_exception

  validates :title, presence: true
  validates :description, presence: true
  def self.pageSize
    50
  end
end
