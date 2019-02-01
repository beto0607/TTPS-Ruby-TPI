class User < ApplicationRecord
    has_secure_password

    has_many :questions

    has_many :answers

    validates :username, uniqueness: true, presence: true
    validates :email, uniqueness: { case_sensitive: false }, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
    validates :password_digest, presence: true
    validates :screen_name, presence: true

    before_save   :downcase_email


    private
    def downcase_email
        self.email.downcase!
    end
end
