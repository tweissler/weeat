require 'rails_helper'
require 'json'
require_relative '../../app/controllers/reviews_controller'

RSpec.describe ReviewsController, type: :controller do

  describe "#show" do
    let!(:rev) { FactoryBot.create(:review) }
    it "retrieve review" do
      get :show, params: { id: rev.id }
      expect(response.status).to eq 200
      body = JSON.parse(response.body)
      expect(body["name"]).to be_present
    end

    it "retrieve non existing review" do
      get :show, params: { id: 12345 }
      expect(response.status).to eq 404
    end
  end

  describe "#index" do
    let!(:rev) { FactoryBot.create_list(:review, 4) }
    it "list reviews" do
      get :index
      expect(response.status).to eq 200
      body = JSON.parse(response.body)
      expect(body.length).to eq 4
    end
  end

  describe "#create" do
    let!(:rest) { FactoryBot.create(:restaurant) }
    it "create review" do
      post :create, params: { name: "rev", restaurant_id: rest.id, rating: 2}
      expect(response.status).to eq 201
      rev = Review.last
      expect(rev["name"]).to eql("rev")
      expect(rev["rating"]).to eql(2)
    end
  end

  describe "#update" do
    let!(:rev) { FactoryBot.create(:review) }
    it "update review" do
      patch :update, params: { id: rev.id, rating: 3 }
      expect(response.status).to eq 200
      body = JSON.parse(response.body)
      expect(body["rating"]).to eql(3)
    end
  end

  describe "#destroy" do
    let!(:rev) { FactoryBot.create(:review) }
    it "delete review" do
      delete :destroy, params: { id: rev.id }
      expect(response.status).to eq 204
      expect(Review.last).to be_nil
    end
  end

end