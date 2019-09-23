class CreateTodos < ActiveRecord::Migration[6.0]
  def change
    create_table :todos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, default: ''
      t.text :body, default: ''
      t.boolean :done, default: false

      t.timestamps
    end
  end
end
