require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
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
    @params = { question: {description: @question.description, status: @question.status, title: @question.title } }

    @answer = @question.answers.create(content: "test answer", user_id: @otherUser.id)
  end

  # INDEX
  test "should get index" do
    get questions_url, as: :json
    assert_response :success
  end

  # CREATE
  test "should create question" do
    assert_difference('Question.count') do
      post questions_url, 
        params: @params,
        as: :json, 
        headers: { 'X-QA-Key' => @token }
    end
    assert_response 201
  end
  
  test "should not create question - Without token" do
    post questions_url, params: @params, as: :json
    assert_response 401
  end
  
  test "should not create question - Without params" do
    post questions_url, as: :json, headers: { 'X-QA-Key' => @token }
    assert_response 400
  end

  # SHOW
  test "should show question" do
    get question_url(@question)
    assert_response :success
  end

  test "should not show question - 404" do
    @question.answers.delete_all
    @question.destroy
    get question_url(@question)
    assert_response 404
  end

  test "should show question with answers" do
    get question_url(@question) + "?answers=true"
    assert_response :success
    assert response.parsed_body["included"]
  end

  test "should not show question with answers - 404" do
    @question.answers.delete_all
    @question.destroy
    get question_url(@question) + "?answers=true"
    assert_response 404
  end

  # UPDATE
  test "should update question" do
    patch question_url(@question), 
      params: @params,
      as: :json, 
      headers: { 'X-QA-Key' => @token }
    assert_response 200
  end

  test "should not update question - Without token" do
    patch question_url(@question), 
      params: @params,
      as: :json
    assert_response 401
  end

  test "should not update question - User isn't the owner" do
    patch question_url(@question), 
      params: @params,
      as: :json, 
      headers: { 'X-QA-Key' => @token2 }
    assert_response 401
  end

  test "should not update question - No params" do
    patch question_url(@question), 
      as: :json, 
      headers: { 'X-QA-Key' => @token }
    assert_response 400
  end

  test "should not update question - Alredy solved" do
    @question = Question.update(@question.id, status:true)
    patch question_url(@question), 
      params: @params,
      as: :json, 
      headers: { 'X-QA-Key' => @token }
    assert_response 422
  end
  
  test "should not update question - Not found" do
    @question.id = -1
    patch question_url(@question), 
      params: @params,
      as: :json, 
      headers: { 'X-QA-Key' => @token }
    assert_response 404
  end

  # DESTROY
  test "should destroy question" do
    @question.answers.delete_all
    assert_difference('Question.count', -1) do
      delete question_url(@question), as: :json, headers: { 'X-QA-Key' => @token }
    end
    assert_response 204
  end
  
  test "should not destroy question - Without token" do
    delete question_url(@question)
    assert_response 401
  end
  
  test "should not destroy question - User isn't question's owner" do
    delete question_url(@question), headers: { 'X-QA-Key' => @token2 }
    assert_response 401
  end

  test "should not destroy question - Question solved" do
    Question.update(@question.id, status:true)
    delete question_url(@question), headers: { 'X-QA-Key' => @token }
    assert_response 422
  end

  test "should not destroy question - Not found" do
    @question.id = -1
    delete question_url(@question), headers: { 'X-QA-Key' => @token }
    assert_response 404
  end

  test "should not destroy question - Has answers" do
    delete question_url(@question), headers: { 'X-QA-Key' => @token }
    assert_response 422
  end

  # RESOLVE
  test "should resolve question" do
    put question_url(@question)+'/resolve', 
      params: {answer_id: @answer.id}, 
      as: :json, 
      headers: { 'X-QA-Key' => @token }
    assert_response 200
  end

  test "should not resolve question - Already solved" do
    Question.update(@question.id, status:true)
    put question_url(@question)+'/resolve', 
      params: {answer_id: @answer.id}, 
      as: :json, 
      headers: { 'X-QA-Key' => @token }
    assert_response 422
  end
  
  test "should not resolve question - Without token" do
    Question.update(@question.id, status:true)
    put question_url(@question)+'/resolve', 
      params: {answer_id: @answer.id}, 
      as: :json
    assert_response 401
  end
  
  test "should not resolve question - User isn't question's owner" do
    Question.update(@question.id, status:true)
    put question_url(@question)+'/resolve', 
      params: {answer_id: @answer.id}, 
      as: :json, 
      headers: { 'X-QA-Key' => @token2 }
    assert_response 401
  end

  test "should not resolve question - Question not found" do
    @question.id = -1
    put question_url(@question)+'/resolve', 
      params: {answer_id: @answer.id}, 
      as: :json, 
      headers: { 'X-QA-Key' => @token }
    assert_response 404
  end
  test "should not resolve question - Answer doesn't belong to Question" do
    put question_url(@question)+'/resolve', 
      params: {answer_id: -1}, 
      as: :json, 
      headers: { 'X-QA-Key' => @token }
    assert_response 400
  end
end
