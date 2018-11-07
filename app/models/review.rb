class Review < ApplicationRecord
  belongs_to :restaurant

  validates :restaurant_id, presence: true
  validates :rating, numericality: { only_integer: true }, :inclusion => 0..3

end
