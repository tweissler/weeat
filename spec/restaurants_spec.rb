require 'rails_helper'

describe RestaurantsController, type: :controller do


  describe "GET #show" do
    before do
      get :show, id: restaurant.id
    end

    let(:restaurant) { Restaurant.create(name: 'rest1') }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "response with JSON body containing expected Article attributes" do
      hash_body = nil
      expect { hash_body = JSON.parse(response.body).with_indifferent_access }.not_to raise_exception
      expect(hash_body.keys).to match_array([:id, :name, :cuisine, :rating, :tenbis, :address, :delivery_time])
      expect(hash_body).to match({
                                     id: restaurant.id,
                                     name: 'rest1'
                                 })
    end
  end

end