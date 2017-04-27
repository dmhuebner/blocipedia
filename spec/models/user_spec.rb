require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) {create(:user)}

	# Shoulda relational tests
	it {should have_many(:wikis)}
	it {should have_many(:collaborators)}

	# Shoulda attribute validation
	it {should validate_presence_of(:name)}
	it {should validate_length_of(:name).is_at_least(1)}

	it {is_expected.to validate_presence_of(:email)}
	it {is_expected.to validate_uniqueness_of(:email)}
	it {is_expected.to allow_value("user@blocipedia.com").for(:email)}

	it {is_expected.to validate_presence_of(:password)}
	it {should validate_length_of(:password).is_at_least(6)}

	describe "attributes" do
		it "should have name and email attributes" do
			expect(user).to have_attributes(name: user.name, email: user.email)
		end
		it "responds to role" do
			expect(user).to respond_to(:role)
		end
		it "responds to admin?" do
			expect(user).to respond_to(:admin?)
		end
		it "responds to premium?" do
			expect(user).to respond_to(:premium?)
		end
		it "responds to member?" do
			expect(user).to respond_to(:standard?)
		end
	end

	describe "invalid user" do
		let(:user_with_invalid_name) {build(:user, name: "")}
		let(:user_with_invalid_email) {build(:user, email: "")}

		it "should be an invalid user due to blank name" do
			expect(user_with_invalid_name).to_not be_valid
		end
		it "should be an invalid user due to blank email" do
			expect(user_with_invalid_email).to_not be_valid
		end
	end

	describe "roles" do
		it "is standard by default" do
			expect(user.role).to eq("standard")
		end

		context "standard user" do
			it "returns true for #standard?" do
				expect(user.standard?).to be_truthy
			end
			it "returns false for #premium?" do
				expect(user.premium?).to be_falsey
			end
			it "returns false for #admin?" do
				expect(user.admin?).to be_falsey
			end
		end

		context "premium user" do
			before do
				user.premium!
			end
			it "returns false for #standard?" do
				expect(user.standard?).to be_falsey
			end
			it "returns true for #premium?" do
				expect(user.premium?).to be_truthy
			end
			it "returns false for #admin?" do
				expect(user.admin?).to be_falsey
			end
		end

		context "admin user" do
			before do
				user.admin!
			end
			it "returns false for #standard?" do
				expect(user.standard?).to be_falsey
			end
			it "returns false for #premium?" do
				expect(user.premium?).to be_falsey
			end
			it "returns true for #admin?" do
				expect(user.admin?).to be_truthy
			end
		end
	end
end
