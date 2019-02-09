require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(username: 'user', screen_name: 'user', email:'user@user.com', password:'123', password_confirmation: '123')
    @params = { user: { email: @user.email, password:'123', password_confirmation: '123', screen_name: @user.screen_name, username: @user.username } }
    @session_params = {auth: {username: @user.username, password: '123'}}
  end
  def session_url
    '/sessions'
  end

  # CREATE
  test "should create user" do
    @user.delete
    assert_difference('User.count') do
      post users_url, params: @params, as: :json
    end
    assert_response 201
  end

  test "should not create user - Username taken" do
    #username
    @params[:user][:email] = "different@email.com"
    post users_url, params: @params, as: :json
    assert_response 422
  end

  test "should not create user - Email taken" do
    @params[:user][:username] = "different_username"
    #email
    post users_url, params: @params, as: :json
    assert_response 422
  end

  test "should not create user - Password invalid" do
    post users_url, params: { user: { email: @user.email+"a", 
      password:'1234', password_confirmation: '5678', 
      screen_name: @user.screen_name+"a", username: @user.username+"a" } }, as: :json
    assert_response 422
  end
  
  test "should not create user - No params" do
    post users_url, as: :json
    assert_response 400
  end

  # SESSIONS
  test "should login" do
    post session_url, params: @session_params,  as: :json
    assert_response 201
    assert response.parsed_body["token"]
  end

  test "should not login - No params" do
    post session_url, params: {}, as: :json
    assert_response 400
  end

  test "should not login - Not found" do
    @session_params[:auth][:username] = "inexistent"
    post session_url, params: @session_params,  as: :json
    assert_response 404
  end

  test "should not login - Password incorrect" do
    @session_params[:auth][:password] = "incorrect"
    post session_url, params: @session_params,  as: :json
    assert_response 404
  end
end
