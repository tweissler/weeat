require 'factory_bot'

FactoryBot.define do
  factory :restaurant do
    name { Faker::FunnyName.name }
    cuisine {Faker::Friends.character}
    address { Faker::Address.full_address }

    trait :israeli do
      cuisine { "israeli" }
    end

    trait :italian do
      cuisine { "italian" }
    end

    trait :vegan do
      cuisine { "vegan" }
    end

    trait :has_tenbis do
      tenbis { true }
    end

    factory :italian_with_tenbis, traits: [:italian, :has_tenbis]
    factory :vegan_with_tenbis, traits: [:vegan, :has_tenbis]
  end
end