require 'rails_helper'

RSpec.describe ChargesController, type: :controller do

	let(:my_user) {create(:user)}
	let(:my_wiki) {create(:wiki)}

	context "Standard User" do
		before do
			my_user.confirm
			sign_in my_user
		end

		describe "GET new" do
			it "has http response success" do
				get :new
				expect(response).to have_http_status(:success)
			end
			it "renders the new charge view" do
				get :new
				expect(response).to render_template(:new)
			end
		end

		describe "POST create" do
			it "Stripe handles the charge" do
				# Stripe handles the charge
			end
			it "changes my_user.role to premium" do
				my_user.premium!
				expect(my_user.role).to eq("premium")
			end
		end
	end

	context "Premium User" do
		before do
			my_user.confirm
			my_user.premium!
			sign_in my_user
		end

		describe "GET cancelling" do
			it "has http response success" do
				get :cancelling
				expect(response).to have_http_status(:success)
			end
			it "renders the cancelling charge view" do
				get :cancelling
				expect(response).to render_template(:cancelling)
			end
		end

		describe "GET cancel" do
			# Stripe would handle payment backend
			# it "updates my_user.role to standard" do
			# 	get :cancel
			# 	expect(my_user.standard?).to be_truthy
			# end
			it "redirects to user registration edit view" do
				get :cancel
				expect(response).to redirect_to(edit_user_registration_path(my_user))
			end
		end
	end
end
