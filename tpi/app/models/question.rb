class Question < ApplicationRecord
  belongs_to :user
  has_one :answer, dependent: :restrict_with_exception
end
