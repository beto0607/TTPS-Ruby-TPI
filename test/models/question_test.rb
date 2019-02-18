require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  test "Create question" do
    assert FactoryGirl.build(:question).valid?
  end

  test "Lack of parameters - Title" do
    q = FactoryGirl.build(:question, title: nil)
    assert_not q.valid?
  end

  test "Lack of parameters - Description" do
    q = FactoryGirl.build(:question, description: nil)
    assert_not q.valid?
  end

  test "Lack of parameters - User" do
    q = FactoryGirl.build(:question, user: nil)
    assert_not q.valid?
  end

  test "Status is always false when create a question" do 
    q = FactoryGirl.create(:question, status: true)
    assert_not q.status
  end

  test "User doesn't exists" do 
    q = FactoryGirl.build(:question, user_id: -1)
    assert_not q.valid?
  end
end
