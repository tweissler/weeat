class Restaurant < ApplicationRecord

  after_initialize :set_default_values

  validates :name, presence: true, uniqueness: true
  validates :delivery_time, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :tenbis, inclusion: [true, false]

  def set_default_values
    self.rating ||= 0
    self.tenbis ||= false
    self.delivery_time ||= 0
  end

end
