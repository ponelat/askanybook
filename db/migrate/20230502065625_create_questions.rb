class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :question
      t.string :answer
      t.integer :prompt_tokens
      t.integer :answer_tokens
      t.text :prompt
      t.integer :asked_count

      t.timestamps
    end
  end
end
