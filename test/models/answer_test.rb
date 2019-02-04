require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  setup do
    @user = User.create(
      username: "answerOwner",
      email: "answerOwner@answer.com",
      screen_name: "Answer Owner",
      password: "pass",
      password_confirmation: "pass"
    )
    @question = @user.questions.create(
      title: "Test question",
      description: "Test question"
    )
    @answer = Answer.create(
      user_id: @user.id,
      question_id: @question.id,
      content: "Answer content"
    )
  end

  test "Create answer" do
    a = Answer.create(
      user_id: @user.id,
      question_id: @question.id,
      content: "Answer content"
    )
    assert a.persisted?
  end

  test "Cannot create answer without all parameter" do
    a = Answer.create(
      user_id: @user.id,
      question_id: @question.id
      #No content
    )
    assert_not a.persisted?
    a = Answer.create(
      question_id: @question.id,
      content: "No user"
    )
    assert_not a.persisted?
    a = Answer.create(
      user_id: @user.id,
      content: "No question"
    )
    assert_not a.persisted?
  end
end
