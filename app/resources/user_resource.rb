class UserResource < JSONAPI::Resource
    
    attributes :username, :email, :screen_name
    has_many :answer
    has_many :question
 end
  