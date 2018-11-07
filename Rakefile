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

  JSON.parse(response.body)["restaurants"].each do |rest|
    Restaurant.find_or_create_by(:name => rest["restaurant"]["name"], :cuisine => rest["restaurant"]["cuisines"].split(",").first,
                      :address => rest["restaurant"]["location"]["address"] + rest["restaurant"]["location"]["city"],
                      :rating => (rest["restaurant"]["user_rating"]["aggregate_rating"].to_i%3))
  end
end

