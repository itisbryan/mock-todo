class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.text :content, null: false
      t.datetime :expired_at
      t.bigint :todo_id, null: false
      t.bigint :user_id, null: false
      t.string :status, null: false
      t.boolean :is_public, null: false, default: true

      t.timestamps
    end

    add_foreign_key :tasks, :todos, column: :todo_id
    add_foreign_key :tasks, :users, column: :user_id
  end
end
