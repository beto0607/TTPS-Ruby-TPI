require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  test "create user" do
    post '/users', params: {
      username: "testUser1",
      email: "test@test1.com",
      password: "passtest",
      screen_name: "test name"
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json"
    }, as: :json
    assert_equal 201, status
  end
  test "cannot create user" do
    post '/users', params: {
      username: "testUser1",
      email: "test@test1.com",
      password: "passtest",
      screen_name: "test name"
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json"
    }, as: :json
    post '/users', params: {
      username: "testUser1",
      email: "test@test1.com",
      password: "passtest",
      screen_name: "test name"
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json"
    }, as: :json
    assert_equal 409, status
  end

  test "login user" do
    post '/users', params: {
      username: "testUser1",
      email: "test@test1.com",
      password: "passtest",
      screen_name: "test name"
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json"
    }, as: :json

    post '/sessions', params: {
      username: "testUser1",
      password: "passtest",
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json"
    }, as: :json
    assert_equal 200, status
  end

  test "cannot login user" do
    post '/users', params: {
      username: "testUser1",
      email: "test@test1.com",
      password: "passtest",
      screen_name: "test name"
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json"
    }, as: :json

    post '/sessions', params: {
      username: "testUser1",
      password: "passtestadfaf",
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json"
    }, as: :json
    assert_equal 404, status
  end
end
