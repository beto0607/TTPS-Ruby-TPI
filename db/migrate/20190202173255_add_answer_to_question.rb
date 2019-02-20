class AddAnswerToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :answer, null:true, foreign_key: true
    add_column :questions, :answers_counter, :integer, default: 0
  end
end
