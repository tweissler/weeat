class Restaurant < ApplicationRecord

  after_initialize :set_default_values

  validates :name, presence: true, uniqueness: true
  #TODO: should floats be allowed in rating? is it a stars format or a grade format?
  validates :rating, numericality: { only_integer: true }, :inclusion => 0..3
  validates :delivery_time, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  #TODO: this is done here and not in the schema because I understood this is how the tram works
  def set_default_values
    self.rating ||= 0
    self.tenbis ||= false
    self.delivery_time ||= 0 #TODO: does that make sense?
  end

end
