require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user) {create(:user)}

	# Shoulda relational tests
	it {should have_many(:wikis)}

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
end
