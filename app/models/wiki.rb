class Wiki < ActiveRecord::Base
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
end
