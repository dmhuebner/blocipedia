class Wiki < ActiveRecord::Base
  belongs_to :user

	default_scope { order('updated_at DESC') }

	validates :title, presence: true, length: {minimum: 2}
	validates :body, presence: true, length: {minimum: 20}
	validates :user, presence: true
end
