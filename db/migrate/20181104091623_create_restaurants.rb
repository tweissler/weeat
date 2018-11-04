class CreateRestaurants < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :cuisin
      t.int :rating
      t.boolean :tenbis
      t.text :address
      t.int :delivery_time

      t.timestamps
    end
  end
end
