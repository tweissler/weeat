require_relative './application_controller'
require 'active_record'

class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, :with => :invalid_id_handler

  # GET /restaurants/reviews
  def index
    @reviews = Review.all
    render :json => @reviews
  end

  # GET /restaurants/reviews/:id
  def show
    render :json => @review
  end

  #POST /restaurants/reviews
  def create
    begin
      @review = Review.create!(review_params)
      update_rating @review.restaurant_id
      render status: :created, json: @review
    rescue StandardError => e
      render status: :bad_request, json: {message: 'Failed to add a review. Please try again :('}.to_json
    end
  end

  #PATCH /restaurants/reviews:/:id
  def update
    begin
      @review.update!(review_params)
      update_rating @review.restaurant_id
      render status: :ok, json: @review
    rescue StandardError => e
      render status: :bad_request, json: {message: 'Failed to update a review. Please try again :('}.to_json
    end
  end

  #DELETE /restaurants/reviews/:id
  def destroy
    @review.destroy
    head :no_content
  end

  private

  def set_review
    params.require(:id)
    @review = Review.find(params[:id])
  end

  def review_params
    params.permit(:id, :name, :rating, :comment, :restaurant_id)
  end

  def invalid_id_handler
    render status: :not_found
  end

  def update_rating rest_id
    r = Restaurant.find(rest_id)
    rating = get_restaurant_rating r.id
    Restaurant.update(r.id, {rating: r.rating}) if rating != r.rating
  end

  def get_restaurant_rating(rest_id)
    reviews = Review.where(:restaurant_id => rest_id)
    return 0 if reviews.empty?
    rev_sum = 0
    reviews.each { |rev| rev_sum += rev.rating }
    rev_sum/reviews.length
  end

end
