class CreateEverything < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, unique: true
      
      t.timestamp
    end
    
    create_table :polls do |t|
      t.string :title
      t.integer :author_id
      
      t.timestamp
    end
    
    create_table :questions do |t|
      t.text :text
      t.integer :poll_id
      
      t.timestamp
    end
    
    create_table :answer_choices do |t|
      t.text :text
      t.integer :question_id
      
      t.timestamp
    end
    
    create_table :responses do |t|
      t.integer :user_id
      t.integer :answer_choice_id
      
      t.timestamp
    end
  end
  
end
