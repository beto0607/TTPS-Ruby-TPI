require 'test_helper'

class AnswerTest < ActiveSupport::TestCase

  test "Create answer" do
    assert FactoryGirl.build(:answer).valid?
  end

  test "Lack of parameters - Content" do
    answer = FactoryGirl.build(:answer, content: nil)
    assert_not answer.valid?
  end
  
  test "Lack of parameters - User" do
    answer = FactoryGirl.build(:answer, user: nil)
    assert_not answer.valid?
  end
  
  test "Lack of parameters - Question" do
    answer = FactoryGirl.build(:answer, question: nil)
    assert_not answer.valid?
  end
end
