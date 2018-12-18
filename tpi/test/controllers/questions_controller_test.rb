require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
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
    @token = response.parsed_body["data"]["attributes"]["token"]
  end
  test "create question" do
    post '/questions', params: {
      title: 'title 123123',
      description: "desc"
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json",
      "X-QA-Key": @token
    }, as: :json
    assert_equal 201, status
  end
  test "cannot create question - no token" do
    post '/questions', params: {
      title: 'title 123123',
      description: "desc"
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json"
    }, as: :json
    assert_equal 400, status
  end
  test "cannot create question - no data" do
    post '/questions', params: {
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json"
    }, as: :json
    assert_equal 400, status
  end

  test "delete question" do
    post '/questions', params: {
      title: 'title 123123',
      description: "desc"
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json",
      "X-QA-Key": @token
    }, as: :json
    id = response.parsed_body["data"]["id"]
    delete "/questions/#{id}", headers:{
      "X-QA-Key": @token
    }
    assert_equal 204, status
  end
  test "delete question - no token" do
    post '/questions', params: {
      title: 'title 123123',
      description: "desc"
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json",
      "X-QA-Key": @token
    }, as: :json
    
    id = response.parsed_body["data"]["id"]
    
    delete "/questions/#{id}"
    assert_equal 400, status
  end
  test "delete question - already deleted" do
    post '/questions', params: {
      title: 'title 123123',
      description: "desc"
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json",
      "X-QA-Key": @token
    }, as: :json
    
    id = response.parsed_body["data"]["id"]
    delete "/questions/#{id}", headers:{
      "X-QA-Key": @token
    }
    delete "/questions/#{id}", headers:{
      "X-QA-Key": @token
    }
    assert_equal 404, status
  end
  test "delete question - cannot deleted solved" do
    post '/questions', params: {
      title: 'title 123123',
      description: "desc"
    }, headers:{
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json",
      "X-QA-Key": @token
    }, as: :json
    
    id = response.parsed_body["data"]["id"]

    post "/questions/#{id}/answers", params: {
      content: "KAEFERF"
    }, as: :json, headers:{
      "X-QA-Key": @token,
      HTTP_ACCEPT: "application/vnd.api+json",
      CONTENT_TYPE: "application/json"
    }
    assert_equal 200, status
    answer_id = response.parsed_body["data"]["id"]

    put "/questions/#{id}/resolve", params: {
      answer_id: answer_id
    },as: :json, headers:{
      "X-QA-Key": @token
    }
    assert_equal 204, status
    
    delete "/questions/#{id}", headers:{
      "X-QA-Key": @token
    }
    assert_equal 400, status
  end
end
