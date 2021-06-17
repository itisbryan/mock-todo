class CreateTodos < ActiveRecord::Migration[6.1]
  def change
    create_table :todos do |t|
      t.string :title, null: false
      t.string :short_description
      t.bigint :user_id, null: false
      t.boolean :is_public, null: false, default: true

      t.timestamps
    end

    add_foreign_key :todos, :users, column: :user_id
  end
end
