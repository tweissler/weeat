require 'rails_helper'
include FactoryBot::Syntax::Methods

FactoryBot.define do
  factory :restaurant do
    sequence :name do |n|
      "rest#{n}"
    end
    cuisine {"cuisine"}
    address {"address"}
  end
end