require 'rails_helper'
include FactoryBot::Syntax::Methods

FactoryBot.define do
  factory :restaurant do
    name {"rest"}
    cuisine {"cuisine"}
  end
end