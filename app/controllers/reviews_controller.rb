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
      render status: :created, json: @review
    rescue StandardError => e
      render status: :bad_request, json: {message: 'Failed to add a review. Please try again :('}.to_json
    end
  end

  #PATCH /restaurants/reviews:/:id
  def update
    begin
      @review.update!(review_params)
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

end
