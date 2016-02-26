class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
    	t.string :title
    	t.text :body
    	t.string :created_by
    	t.string :aproved_by
    	t.boolean :approved
    	t.string :tag
      t.timestamps null: false
    end
  end
end
