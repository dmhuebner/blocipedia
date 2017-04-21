require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do

	let(:user) {create(:user)}

	context "Guest" do
		describe "GET #index" do
	    it "returns http success" do
	      get :index
	      expect(response).to have_http_status(:success)
	    end
	  end

	  describe "GET #about" do
	    it "returns http success" do
	      get :about
	      expect(response).to have_http_status(:success)
	    end
	  end
	end

	context "User" do
		before do
			user.confirm
			sign_in user
		end
		describe "GET #index" do
			it "redirects to wikis index" do
				get :index
				expect(response).to redirect_to(:wikis)
			end
		end

		describe "GET #about" do
			it "returns http success" do
				get :about
				expect(response).to have_http_status(:success)
			end
		end
	end

end
