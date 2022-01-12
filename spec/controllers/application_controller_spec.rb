require 'rails_helper'
RSpec.describe ApplicationController, :type => :controller do
  describe "GET index" do
    it "should pass request and print Allowed Request!" do

      get :track_rate_limit
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Allowed Request!")
      sleep(10)

      get :track_rate_limit
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Allowed Request!")
      sleep(10)

      get :track_rate_limit
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Allowed Request!")
      sleep(10)

      get :track_rate_limit
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Allowed Request!")
      sleep(20)

      get :track_rate_limit
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Allowed Request!")

      2.times {get :track_rate_limit}
      expect(response).to have_http_status(:too_many_requests)
      expect(response.body).to include("Too many requests!")
      sleep(30)

      3.times {get :track_rate_limit}
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Allowed Request!")

      get :track_rate_limit
      expect(response).to have_http_status(:too_many_requests)
      expect(response.body).to include("Too many requests!")
    end

  end
end