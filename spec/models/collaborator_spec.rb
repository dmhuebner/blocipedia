require 'rails_helper'

RSpec.describe Collaborator, type: :model do
	let(:user) {create(:user)}
	let(:wiki) {create(:wiki)}

	# Shoulda relationship tests
	it {should belong_to(:user)}
	it {should belong_to(:wiki)}

	it {should validate_presence_of(:wiki_id)}
	it {should validate_presence_of(:user_id)}
end
