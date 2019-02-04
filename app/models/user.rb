class User < ApplicationRecord
    has_secure_password

    has_many :questions

    has_many :answers

    validates :questions, presence: false
    validates :answers, presence: false
    validates :username, uniqueness: true, presence: true
    validates :email, uniqueness: { case_sensitive: false }, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
    validates :password_digest, presence: true
    validates :screen_name, presence: true

    before_save :downcase_email



    def self.from_token_request request
        username = request.params["auth"] && request.params["auth"]["username"]
        self.find_by username: username
    end


    
    private
    def downcase_email
        self.email.downcase!
    end
end
