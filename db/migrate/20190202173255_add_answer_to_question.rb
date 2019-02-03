class AddAnswerToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :answer, null:true, foreign_key: true
  end
end
