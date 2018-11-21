require 'active_record'

class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_id_handler

  # GET /restaurants
  def index
    @restaurants = Restaurant.all
    @restaurants = @restaurants.where('cuisine = ?', query_params["by_cuisine"]) if query_params.has_key? "by_cuisine"
    @restaurants = @restaurants.where('delivery_time <= ?', query_params["max_delivery_time"].to_i) if query_params.has_key? "max_delivery_time"
    @restaurants = @restaurants.where('rating >= ?', query_params["min_rating"].to_i) if query_params.has_key? "min_rating"
    @restaurants = @restaurants.where('name LIKE :prefix', prefix: "#{query_params["by_name"]}%") if query_params.has_key? "by_name"
    response.headers['Access-Control-Allow-Origin'] = '*'
    render :json => @restaurants
  end

  # GET /restaurants/:id
  def show
    response.headers['Access-Control-Allow-Origin'] = '*'
    render :json => @restaurant
  end

  #POST /restaurants
  def create
    begin
      @restaurant = Restaurant.create!(restaurant_params)
      response.headers['Access-Control-Allow-Origin'] = '*'
      render status: :created, json: @restaurant
    rescue StandardError => e
      render status: :bad_request, json: {message: "Failed to add a restaurant. Please try again :( #{e.message}"}.to_json
    end
  end

  #PATCH /restaurants:/:id
  def update
    begin
      @restaurant.update!(restaurant_params)
      response.headers['Access-Control-Allow-Origin'] = '*'
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
    response.headers['Access-Control-Allow-Origin'] = '*'
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
    request.query_parameters.slice(:by_cuisine, :min_rating, :max_delivery_time, :by_name)
  end

  def invalid_id_handler
    response.headers['Access-Control-Allow-Origin'] = '*'
    render status: :not_found
  end

end
