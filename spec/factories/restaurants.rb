require 'factory_bot'

FactoryBot.define do
  factory :restaurant do
    name { Faker::FunnyName.name }
    cuisine {Faker::Friends.character}
    address { Faker::Address.full_address }
  end
end