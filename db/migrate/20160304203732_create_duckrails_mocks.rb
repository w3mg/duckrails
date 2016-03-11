class CreateDuckrailsMocks < ActiveRecord::Migration
  def change
    create_table :mocks do |t|
      t.string :name, null: false
      t.text :description
      t.integer :status, null: false
      t.string :content_type, null: false
      t.string :method, null: false
      t.string :route_path, null: false
      t.text :content, null: false
      t.string :body_type

      t.timestamps null: false
    end

    add_index :mocks, :route_path, unique: true
    add_index :mocks, :name, unique: true
  end
end
