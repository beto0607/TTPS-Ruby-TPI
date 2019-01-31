class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens do |t|
      t.string :token
      t.datetime :expire_at
      t.references :user, foreign_key: true

      #t.timestamps
    end
  end
end
