class User < ApplicationRecord
    has_secure_password

    has_many :questions

    has_many :answers

    validates :username, uniqueness: true, presence: true
    validates :email, uniqueness: { case_sensitive: false }, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
    validates :password_digest, presence: true
    validates :screen_name, presence: true

    before_save   :downcase_email


    def to_token_payload
        # Returns the payload as a hash
        p headers['X-QA-Key']
        headers['X-QA-Key']

    end

    private
    def downcase_email
        self.email.downcase!
    end
end
