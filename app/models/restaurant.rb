class Restaurant < ApplicationRecord

  validates :name, presence: true
  validates :rating, :inclusion => 0..3
  validates :delivery_time, :numericality => { :greater_than_or_equal_to => 0 }

end
