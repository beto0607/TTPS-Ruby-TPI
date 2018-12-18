class Token < ApplicationRecord
  belongs_to :user
  
  validates :token, uniqueness: true, presence: true
  validates :expire_at, presence: true

  def self.createToken
    t = SecureRandom.base58(24)
    while(Token.find_by(token: t))do
      t = SecureRandom.base58(24)
    end
    t
  end

  def self.nextExpireDateTime
    DateTime.now + 30.minutes
  end
end
