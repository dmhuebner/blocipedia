# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'random_data'

# Seed users
5.times do
	pw = RandomData.random_password
	u = User.create!(
		name: Faker::Name.unique.name,
		email: Faker::Internet.email,
		password: pw
	)
	u.confirm
end

# Create admin user
admin = User.create!(
	name: "Admin User",
	email: "admin@example.com",
	password: "helloworld",
	role: "admin"
)
admin.confirm

# Create premium user
premium = User.create!(
	name: "Premium User",
	email: "premium@example.com",
	password: "helloworld",
	role: "premium"
)
premium.confirm

# Create standard user
standard = User.create!(
	name: "Standard User",
	email: "standard@example.com",
	password: "helloworld"
)
standard.confirm

users = User.all


# Create public wikis
40.times do
	wiki = Wiki.create!(
		title: Faker::Lorem.sentence,
		body: Faker::Lorem.paragraph(15),
		user: users.sample,
		private: false
	)
end

# Create private wikis
10.times do
	wiki = Wiki.create!(
		title: Faker::Lorem.sentence,
		body: Faker::Lorem.paragraph(15),
		user: users.sample,
		private: true
	)
end
wikis = Wiki.all

# No private wikis for Standard users.
users.each do |u|
	if u.standard?
		u.wikis.each do
			w.private = false
			w.save
		end
	end
end

puts "Seed finished"
puts "#{users.count} users created"
puts "#{Wiki.count} wikis created"
