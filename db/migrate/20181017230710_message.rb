class Message < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
		t.text :content
		t.integer :status
		t.references :user, foreign_key: true
		t.float :lng
		t.float :lat
		t.timestamps null: false
    end
  end
end
