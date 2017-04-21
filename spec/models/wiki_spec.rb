require 'rails_helper'

RSpec.describe Wiki, type: :model do
  let(:user) {create(:user)}
	let(:wiki) {create(:wiki)}

	# Shoulda relational tests
	it {should belong_to :user}

	it {should validate_presence_of(:title)}
	it {should validate_presence_of(:body)}
	it {should validate_presence_of(:user)}

	it {should validate_length_of(:title).is_at_least(2)}
	it {should validate_length_of(:body).is_at_least(20)}

	describe "attributes" do
		it "has title, body, and user attributes" do
			expect(wiki).to have_attributes(title: wiki.title, body: wiki.body, user: wiki.user)
		end
	end
end
