class UsersController < ApplicationController
  before_action :user_params, only: [:create]

  #POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: 
        JSONAPI::ResourceSerializer.new(UserResource,
          fields:{
            users:[:screen_name, :email, :username],
            liks:[:self]
          }).serialize_to_hash(UserResource.new(@user, nil)), 
      status: :created
    else
      render json:{errors: @user.errors}, status: :unprocessable_entity
    end
  end

  def user_url
    # Knock - Solution for NoMethodError
    users_url
  end
  private
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :username, :screen_name, :password, :password_confirmation)
    rescue ActionController::ParameterMissing
      render json: {error: {title:"Params required: user{email, username, screen_name, password, password_confirmation}"}}, status: :bad_request
    end
end
