require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  setup do
    @user = User.create(
      username: "question_owner",
      password: "pass",
      password_confirmation: "pass",
      email: "email@email.com",
      screen_name: "Question Owner"
    )
  end
  test "Create question" do
    q = Question.create(
      user_id: @user.id,
      title: "Question created",
      description: "Question test"
    )
    assert q.persisted?
  end
  test "Cannot create question without all parameters" do
    q = Question.create(
      user_id: @user.id,
      description: "No title"
    )
    assert_not q.persisted?
    q = Question.create(
      user_id: @user.id,
      title: "No description"
    )
    assert_not q.persisted?
    q = Question.create(
      description: "No user",
      title: "No user"
    )
    assert_not q.persisted?
  end

  test "Cannot set status to true when create" do 
    q = Question.create(
      user_id: @user.id,
      title: "Status allways start with false",
      description: "Status allways start with false",
      status: true,
      answer_id: 1
    )
    assert q.persisted?
    assert_not q.status
    assert_nil q.answer_id
  end
end
