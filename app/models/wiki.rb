class Wiki < ActiveRecord::Base
	extend FriendlyId

	friendly_id :title, use: :slugged

  belongs_to :user
	has_many :collaborators
	has_many :users, through: :collaborators

	default_scope { order('updated_at DESC') }

	validates :title, presence: true, length: {minimum: 2}
	validates :body, presence: true, length: {minimum: 20}
	validates :user, presence: true

	def possible_collaborators
		#User.all.reject{|u| u.id != user.id || collaborators.include?(u.id)}
	end

	def collaborator_name(user_id)
		if user_id
			c = collaborators.find_by_user_id(user_id)
			return c
		else
			collaborators.first
		end
	end
end
