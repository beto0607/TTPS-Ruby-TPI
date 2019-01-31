require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  test "Cannot be created without content" do
    assert_not Answer.create(user_id: 1, question_id: 1).valid?
  end
end
