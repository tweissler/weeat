# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'faraday'
require 'json'

Rails.application.load_tasks

desc "Load restaurant data from Zomato"
task :load_rest_data => :environment do
  conn = Faraday.new(:url => 'https://developers.zomato.com')
  response = conn.get do |req|
    req.url '/api/v2.1/search'
    req.headers['Accept'] = 'application/json'
    req.headers['user-key'] = '8b2556078be72aaf91ae66fd56280f18'
  end

  JSON.parse(response.body)["reviews"].each do |rest|
    review.find_or_create_by(:name => rest["review"]["name"], :cuisine => rest["review"]["cuisines"],
                      :address => rest["review"]["location"]["address"] + rest["review"]["location"]["city"],
                      :rating => (rest["review"]["user_rating"]["aggregate_rating"].to_i%3))
  end
end

