require 'test_helper'

class AnswersControllerTest < ActionDispatch::IntegrationTest
  setup do
    # User, owner of question
    @questionOwner = User.create(username: "test", email: "test@tets.com",password: "test", password_confirmation: "test", screen_name: "screen_name")
    post '/sessions', params: {auth:{username: @questionOwner.username, password: @questionOwner.password}}
    @token = response.parsed_body["token"]
    #Other user, created for check ownership
    @otherUser = User.create(username: "test2", email: "test2@tets.com",password: "test2", password_confirmation: "test2", screen_name: "screen_name2")
    post '/sessions', params: {auth:{username: @otherUser.username, password: @otherUser.password}}
    @token2 = response.parsed_body["token"]
    
    @question = @questionOwner.questions.create(
      title: "New question",
      description: "new question description",
    )
    
    @answer = @question.answers.create(content: "test answer", user_id: @otherUser.id)
    @answer2 = @question.answers.create(content: "test answer2", user_id: @questionOwner.id)
    @params = { answer: { question_id: @answer.question_id, user_id: @answer.user_id, content: @answer.content } }
  end
  def generateURL
    question_url(@question)+ '/answers'
  end
  # INDEX
  test "should get index" do
    get generateURL, as: :json
    assert_response :success
  end

  test "should not get index - Not found" do
    @question.id = -1
    get generateURL, as: :json
    assert_response 404
  end

  # CREATE
  test "should create answer" do
    assert_difference('Answer.count') do
      post generateURL, params: @params, as: :json, headers: { 'X-QA-Key' => @token }
    end
    assert_response 201
  end

  test "should not create index - Not found" do
    @question.id = -1
    post generateURL, params: @params, as: :json, headers: { 'X-QA-Key' => @token }
    assert_response 404
  end

  test "should not create index - No token" do
    post generateURL, params: @params, as: :json
    assert_response 401
  end

  test "should not create index - No params" do
    post generateURL, headers: { 'X-QA-Key' => @token }
    assert_response 400
  end

  test "should not create index - Solved" do
    @question = Question.update(@question.id, status: true)
    post generateURL, params: @params, as: :json, headers: { 'X-QA-Key' => @token }
    assert_response 422
  end

  # DELETE
  test "should destroy answer" do
    assert_difference('Answer.count', -1) do
      delete generateURL + "/#{@answer2.id}", as: :json, headers: { 'X-QA-Key' => @token }
    end
    assert_response 204
  end

  test "should not destroy answer - No token" do
    delete generateURL + "/#{@answer2.id}", as: :json
    assert_response 401
  end

  test "should not destroy answer - User isn't the owner" do
    delete generateURL + "/#{@answer2.id}", as: :json, headers: { 'X-QA-Key' => @token2 }
    assert_response 401
  end

  test "should not destroy answer - Answer is solution" do
    @question = Question.update(@question.id, status: true, answer_id: @answer2.id)
    delete generateURL + "/#{@answer2.id}", as: :json, headers: { 'X-QA-Key' => @token }
    assert_response 400
  end

  test "should not destroy answer - Answer not found" do
    delete generateURL + "/#{-1}", as: :json
    assert_response 404
  end

  test "should not destroy answer - Question not found" do
    @question.id = -1
    delete generateURL + "/#{@answer2.id}", as: :json
    assert_response 404
  end
end
