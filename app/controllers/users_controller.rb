class UsersController < ApplicationController
  #before_action :user_params, only: [:create]

  #POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render_json serialize_model(@user), :created
    else
      render_json({:errors => @user.errors}, :unprocessable_entity)
    end
  end

  def user_url
    # Knock - Solution for NoMethodError
    users_url
  end

  
  private
    def user_params
      params.require(:user).permit(:email, :username, :screen_name, :password, :password_confirmation)
    end
end
