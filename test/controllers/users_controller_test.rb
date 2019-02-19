require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def session_url
    '/sessions'
  end
  # CREATE
  test "should create user" do
    user = FactoryGirl.attributes_for(:user)
    post users_url, params: {user: user}, as: :json
    assert_response 201
  end

  test "should not create user - Username taken" do
    user_params = FactoryGirl.attributes_for(:user)
    FactoryGirl.create(:user, username: user_params[:username])
    post users_url, params: {user: user_params}, as: :json
    assert_response 422
  end

  test "should not create user - Email taken" do
    user_params = FactoryGirl.attributes_for(:user)
    FactoryGirl.create(:user, email: user_params[:email])
    post users_url, params: user_params, as: :json
    assert_response 422
  end

  test "should not create user - Password invalid" do
    user_params = FactoryGirl.attributes_for(:user, password: "123", password_confirmation: "456")
    post users_url, params: { user: user_params}, as: :json
    assert_response 422
  end
  
  test "should not create user - No params" do
    post users_url, as: :json
    assert_response 400
  end

  # SESSIONS
  test "should login" do
    u = FactoryGirl.create(:user)
    post session_url, params: {auth: {username: u.username, password: u.password}},  as: :json
    assert_response 201
  end

  test "should not login - No params" do
    post session_url, params: {}, as: :json
    assert_response 400
  end

  test "should not login - Not found" do
    u = FactoryGirl.attributes_for(:user)
    post session_url, params: {auth: u},  as: :json
    assert_response 404
  end

  test "should not login - Password incorrect" do
    u = FactoryGirl.create(:user)
    u.password = "wrong_password"
    post session_url, params: {auth: {username: u.username, password: u.password}},  as: :json
    assert_response 404
  end
end
