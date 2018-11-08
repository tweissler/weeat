class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.string :name
      t.text :comment
      t.integer :rating
      t.belongs_to :restaurant, foreign_key: true

      t.timestamps
    end
  end
end
