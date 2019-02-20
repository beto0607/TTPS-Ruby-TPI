class UserSerializer < BaseSerializer
  attributes :id, :email, :username, :screen_name, :created_at, :updated_at
  def self_link
    nil
  end

end
