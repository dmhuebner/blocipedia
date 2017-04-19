FactoryGirl.define do
	pw = RandomData.random_password

  factory :user do
    name RandomData.random_name
		sequence(:email){|n| "user#{n}@factory.com"}
		password pw
		password_confirmation pw
  end
end
