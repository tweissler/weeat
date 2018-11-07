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
