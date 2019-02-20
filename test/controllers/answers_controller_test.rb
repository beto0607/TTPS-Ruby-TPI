require 'test_helper'

class AnswersControllerTest < ActionDispatch::IntegrationTest
  # INDEX
  test "should get index" do
    a = FactoryGirl.create(:answer)
    get generateURL(a.question_id), as: :json
    assert_response :success
  end

  test "should not get index - Not found" do
    get generateURL(-1), as: :json
    assert_response 404
  end

  # CREATE
  test "should create answer" do 
    setup_question
    post generateURL(@question.id), params: answer_params, as: :json, headers: { 'X-QA-Key' => @token }
    assert_response 201
  end

  test "should not create - Not found" do 
    post generateURL(-1), params: answer_params, as: :json, headers: { 'X-QA-Key' => "Anythin"}
    assert_response 404
  end

  test "should not create - No token" do 
    setup_question
    post generateURL(@question.id), params: answer_params, as: :json
    assert_response 401
  end

  test "should not create - No params" do 
    setup_question
    post generateURL(@question.id), headers: { 'X-QA-Key' => @token }
    assert_response 400
  end

  test "should not create - Solved" do 
    setup_question
    Question.update(@question.id, status: true)
    post generateURL(@question.id), params: answer_params, as: :json, headers: { 'X-QA-Key' => @token }
    assert_response 422
  end

  # DELETE
  test "should destroy answer" do
    setup_answer
    assert_difference('Answer.count', -1) do
      delete generateURL(@question.id) + "/#{@answer.id}", as: :json, headers: { 'X-QA-Key' => @answer_owner_token}
    end
    assert_response 204
  end

  test "should not destroy answer - No token" do
    setup_answer
    delete generateURL(@question.id) + "/#{@answer.id}", as: :json
    assert_response 401
  end

  test "should not destroy answer - User isn't the owner" do
    setup_answer
    delete generateURL(@question.id) + "/#{@answer.id}", as: :json, headers: { 'X-QA-Key' => @token }
    assert_response 401
  end

  test "should not destroy answer - Answer is solution" do 
    setup_answer
    Question.update(@question.id, status: true, answer_id: @answer.id)
    delete generateURL(@question.id) + "/#{@answer.id}", as: :json, headers: { 'X-QA-Key' => @answer_owner_token}
    assert_response 400
  end

  test "should not destroy answer - Answer not found" do 
    setup_question
    delete generateURL(@question.id) + "/#{-1}", as: :json
    assert_response 404
  end

  test "should not destroy answer - Question not found" do 
    delete generateURL(-1) + "/1", as: :json
    assert_response 404
  end


  private 
    def answer_params
      FactoryGirl.attributes_for(:answer)
    end
    def generateURL id
      "/questions/#{id}/answers"
    end
    def get_token_for user_id
      Knock::AuthToken.new(payload: { sub: user_id }).token
    end
    def setup_question
      @question = FactoryGirl.create(:question)
      @token = get_token_for @question.user_id
    end
    def setup_answer
      setup_question
      @answer = FactoryGirl.create(:answer, question_id: @question.id)
      @answer_owner_token = get_token_for(@answer.user_id)
    end
end
