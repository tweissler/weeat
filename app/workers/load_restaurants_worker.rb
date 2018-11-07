require 'sidekiq'

class LoadRestaurantsWorker
  include Sidekiq::Worker

  def perform(*args)
    conn = Faraday.new(:url => 'https://developers.zomato.com')
    response = conn.get do |req|
      req.url '/api/v2.1/search'
      req.headers['Accept'] = 'application/json'
      req.headers['user-key'] = '8b2556078be72aaf91ae66fd56280f18'
    end

    JSON.parse(response.body)["restaurants"].each do |rest|
      created_rest = Restaurant.find_or_create_by(:name => rest["restaurant"]["name"], :cuisine => rest["restaurant"]["cuisines"].split(",").first,
                                                  :address => rest["restaurant"]["location"]["address"] + ", " + rest["restaurant"]["location"]["city"],
                                                  :rating => (rest["restaurant"]["user_rating"]["aggregate_rating"].to_i%3))


      conn = Faraday.new(:url => 'https://developers.zomato.com')
      review_response = conn.get do |req|
        req.url "/api/v2.1/reviews?res_id=#{rest["restaurant"]["id"]}"
        req.headers['Accept'] = 'application/json'
        req.headers['user-key'] = '8b2556078be72aaf91ae66fd56280f18'
      end

      JSON.parse(review_response.body)["user_reviews"].each do |rev|
        Review.find_or_create_by(:name => rev["review"]["user"]["name"], :comment => rev["review"]["review_text"], :rating => rev["review"]["rating"].to_i%3, :restaurant_id => created_rest.id)
      end

    end
  end
end
