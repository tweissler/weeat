require 'factory_bot'

FactoryBot.define do
  factory :review do
    name { Faker::Friends.character }
    rating { Faker::Number.rand(3)}
    comment {Faker::FunnyName.name}
    restaurant_id { FactoryBot.create(:restaurant).id }
  end
end
