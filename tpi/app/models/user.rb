class User < ApplicationRecord
    has_many :questions

    has_many :answers

    has_many :tokens

    validates :username, uniqueness: true, presence: true
    validates :email, uniqueness: true, presence: true
    validates :password, presence: true
    validates :screen_name, presence: true

    def self.userAttributes u
        {
            username: u.username,
            email: u.email,
            screen_name: u.screen_name
        }
    end

    def self.encryptedPassword plain_password
        Digest::SHA1.hexdigest(plain_password)
    end
end
