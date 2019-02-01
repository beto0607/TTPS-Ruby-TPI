class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :description
      t.boolean :status, default: false
      t.belongs_to :user, foreign_key: true
      t.has_one :answer, foreign_key: true, null: true
      t.timestamps
    end
  end
end
