require 'active_record'

class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_id_handler

  # GET /restaurants
  def index
    @restaurants = Restaurant.all
    @restaurants = @restaurants.where('cuisine = ?', query_params["by_cuisine"]) if query_params.has_key? "by_cuisine"
    @restaurants = @restaurants.where('rating >= ?', query_params["min_rating"].to_i) if query_params.has_key? "min_rating"
    @restaurants = @restaurants.where('delivery_time <= ?', query_params["max_delivery_time"].to_i) if query_params.has_key? "max_delivery_time"
    @restaurants.each do |rest|
      rest.rating = get_restaurant_rating rest.id
    end
    render :json => @restaurants
  end

  # GET /restaurants/:id
  def show
    @restaurant.rating = get_restaurant_rating @restaurant.id
    render :json => @restaurant
  end

  #POST /restaurants
  def create
    begin
      @restaurant = Restaurant.create!(restaurant_params)
      render status: :created, json: @restaurant
    rescue StandardError => e
      render status: :bad_request, json: {message: 'Failed to add a restaurant. Please try again :('}.to_json
    end
  end

  #PATCH /restaurants:/:id
  def update
    begin
      @restaurant.update!(restaurant_params)
      render status: :ok, json: @restaurant
    rescue StandardError => e
      render status: :bad_request, json: {message: 'Failed to update a restaurant. Please try again :('}.to_json
    end
  end

  #DELETE /restaurants/:id
  def destroy
    @restaurant.destroy
    head :no_content
  end

  #GET /load
  def load
    LoadRestaurantsWorker.perform_async
    render :status => :ok, json: {:message => 'Loading restaurants'}.to_json
  end

  private

  def set_restaurant
    params.require(:id)
    @restaurant = Restaurant.find(params[:id])
  end

  def restaurant_params
    params.permit(:id, :name, :cuisine, :tenbis, :address, :delivery_time)
  end

  def query_params
    request.query_parameters.slice(:by_cuisine, :min_rating, :max_delivery_time)
  end

  def invalid_id_handler
    render status: :not_found
  end

  def get_restaurant_rating(rest_id)
    reviews = Review.where(:restaurant_id => rest_id)
    return 0 if reviews.empty?
    rev_sum = 0
    reviews.each { |rev| rev_sum += rev.rating }
    rev_sum/reviews.length
  end

end
