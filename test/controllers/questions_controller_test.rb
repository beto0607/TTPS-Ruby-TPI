require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  # INDEX
  test "should get index - order by lastest" do
    setup_latest_questions
    get questions_url, as: :json
    assert_response :ok
    assert_equal "#{@q2}", response.parsed_body["data"][0]["id"]
    assert_equal "#{@q1}", response.parsed_body["data"][1]["id"]
  end

  test "should get index - order by needing_help" do
    setup_pending_first_and_needing_help_questions
    get questions_url+"?sort=needing_help", as: :json
    assert_response :ok
    assert_equal "#{@q2}", response.parsed_body["data"][0]["id"]
    assert_not response.parsed_body["data"][1]
  end

  test "should get index - order by pending_first" do
    setup_pending_first_and_needing_help_questions
    get questions_url+"?sort=pending_first", as: :json
    assert_response :ok
    assert_equal "#{@q2}", response.parsed_body["data"][0]["id"]
    assert_equal "#{@q1}", response.parsed_body["data"][1]["id"]
  end

  # CREATE
  test "should create question" do
    setup_user_and_token
    post questions_url, 
      params: FactoryGirl.attributes_for(:question, user_id: @user.id), 
      as: :json,
      headers: { 'X-QA-Key' => @token }
    assert_response 201
  end
  
  test "should not create question - Without token" do
    post questions_url, params: FactoryGirl.attributes_for(:question), as: :json
    assert_response 401
  end
  
  test "should not create question - Without params" do
    setup_user_and_token
    post questions_url, as: :json, headers: { 'X-QA-Key' => @token }
    assert_response 400
  end

  # SHOW
  test "should show question" do
    question = FactoryGirl.create(:question)
    get question_url(question)
    assert_response :ok
  end
  
  test "should show question and answers" do
    setup_answer
    get question_url(@question) + '?answers=true'
    assert_response :ok
    assert response.parsed_body["included"]
  end

  test "should not show question - 404" do
    get question_url({id: -1})
    assert_response 404
  end

  test "should not show question with answers - 404" do
    get question_url({id: -1}) + "?answers=true"
    assert_response 404
  end

  # UPDATE
  test "should update question" do
    setup_question
    @question.title = "New title"
    patch question_url(@question), 
      params: @question,
      as: :json, 
      headers: { 'X-QA-Key' => @token}
    assert_response 200
  end

  test "should not update question - Without token" do
    question = FactoryGirl.create(:question)
    patch question_url(question), 
      params: question,
      as: :json
    assert_response 401
  end

  test "should not update question - User isn't the owner" do
    question = FactoryGirl.create(:question)
    patch question_url(question), 
      params: question,
      as: :json, 
      headers: { 'X-QA-Key' => "No token" }
    assert_response 401
  end

  test "should not update question - No params" do
    setup_question
    patch question_url(@question), 
      as: :json, 
      headers: { 'X-QA-Key' => @token }
    assert_response 400
  end

  test "should not update question - Alredy solved" do
    setup_question
    @question = Question.update(@question.id, status:true)
    patch question_url(@question), 
      params: @question,
      as: :json, 
      headers: { 'X-QA-Key' => @token }
    assert_response 422
  end
  
  test "should not update question - Not found" do
    patch question_url({id: -1}), 
      params: FactoryGirl.attributes_for(:question),
      as: :json, 
      headers: { 'X-QA-Key' => "Anything" }
    assert_response 404
  end

  # DESTROY
  test "should destroy question" do
    setup_question
    delete question_url(@question), as: :json, headers: { 'X-QA-Key' => @token }
    assert_response 204
  end
  
  test "should not destroy question - Without token" do
    question = FactoryGirl.create(:question)
    delete question_url(question)
    assert_response 401
  end
  
  test "should not destroy question - User isn't question's owner" do
    question = FactoryGirl.create(:question)
    delete question_url(question), headers: { 'X-QA-Key' => "No token" }
    assert_response 401
  end

  test "should not destroy question - Question solved" do
    setup_question
    Question.update(@question.id, status:true)
    delete question_url(@question), headers: { 'X-QA-Key' => @token }
    assert_response 422
  end

  test "should not destroy question - Not found" do
    delete question_url({id: -1}), headers: { 'X-QA-Key' => "Anything"}
    assert_response 404
  end

  test "should not destroy question - Has answers" do
    setup_question
    FactoryGirl.create(:answer, question_id: @question.id)
    delete question_url(@question), headers: { 'X-QA-Key' => @token }
    assert_response 422
  end

  # RESOLVE
  test "should resolve question" do
    setup_answer
    put question_url(@question)+'/resolve', 
      params: {answer_id: @answer.id}, 
      as: :json, 
      headers: { 'X-QA-Key' => @token }
    assert_response 200
  end

  test "should not resolve question - Already solved" do
    setup_answer
    Question.update(@question.id, status:true)
    put question_url(@question)+'/resolve', 
      params: {answer_id: @answer.id}, 
      as: :json, 
      headers: { 'X-QA-Key' => @token }
    assert_response 422
  end

  
  test "should not resolve question - Without token" do
    setup_answer
    put question_url(@question)+'/resolve', 
      params: {answer_id: @answer.id}, 
      as: :json
    assert_response 401
  end
  
  test "should not resolve question - User isn't question's owner" do
    setup_answer
    setup_user_and_token
    put question_url(@question)+'/resolve', 
      params: {answer_id: 1}, 
      as: :json, 
      headers: { 'X-QA-Key' =>  @token}
    assert_response 401
  end

  test "should not resolve question - Question not found" do
    put question_url({id:-1})+'/resolve', 
      params: {answer_id: 1}, 
      as: :json, 
      headers: { 'X-QA-Key' => "Anything" }
    assert_response 404
  end

  test "should not resolve question - Answer doesn't belong to Question" do
    setup_question
    put question_url(@question)+'/resolve', 
      params: {answer_id: -1}, 
      as: :json, 
      headers: { 'X-QA-Key' => @token }
    assert_response 400
  end

  private
    def get_token_for user_id
      Knock::AuthToken.new(payload: { sub: user_id }).token
    end
    def setup_user_and_token
      @user = FactoryGirl.create(:user)
      @token = get_token_for @user.id
    end
    def setup_question
      setup_user_and_token
      @question = FactoryGirl.create(:question, user_id: @user.id)
    end
    def setup_answer
      setup_question
      @answer = FactoryGirl.create(:answer, question_id: @question.id)
    end
    def setup_latest_questions
      @q1 = FactoryGirl.create(:question).id
      @q2 = FactoryGirl.create(:question).id
    end
    def setup_pending_first_and_needing_help_questions
      q = FactoryGirl.create(:question)
      q.update(status:true)
      @q1 = q.id
      @q2 = FactoryGirl.create(:question).id
    end
end
