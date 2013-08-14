class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :uid
      t.string :user
      t.string :text

      t.timestamps
    end
  end
end
