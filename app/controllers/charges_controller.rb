class ChargesController < ApplicationController

	Stripe.api_key = ENV['STRIPE_SECRET_KEY']

	def create
		# Creates a Stripe Customer object, for associating with the charge
		customer = Stripe::Customer.create(
			email: current_user.email,
			card: params[:stripeToken]
		)

		# The charge
		charge = Stripe::Charge.create(
			customer: customer.id, # Note -- This is NOT the user_id
			amount: Amount.default,
			description: "Premium Membership - #{current_user.name}, #{current_user.email}",
			currency: 'usd'
		)

		# Updates current_user.role to "premium"
		current_user.premium!

		flash[:notice] = "Thank you for your payment, #{current_user.name}! Your account has been upgraded to Premium!"
		redirect_to edit_user_registration_path # Or wherever they should be redirected after payment.

		# Stripe will send back CardErrors, with friendly messages when something goes wrong.
		# This 'rescue block' catches and displays those errors
		rescue Stripe::CardError => e
			flash[:alert] = e.message
			redirect_to new_charge_path
	end

	def new
		@stripe_btn_data = {
			key: "#{ Rails.configuration.stripe[:publishable_key] }",
			description: "Premium Membership - #{current_user.name}",
			amount: Amount.default
		}
	end

	def cancelling
	end

	def cancel
		# Stripe action if subscription

		# Update current_user.role to "standard"
		current_user.standard!
		# Update current_user private wikis to public
		current_user.wikis.each do |w|
			w.private = false
			w.save
		end
		flash[:notice] = "Your account has been successfully downgraded to a Standard user."
		redirect_to edit_user_registration_path(current_user)
	end
end
