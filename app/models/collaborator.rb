class Collaborator < ActiveRecord::Base
	belongs_to :user
	belongs_to :wiki

	validates :user_id, presence: true
	validates :wiki_id, presence: true

	validates_uniqueness_of :user_id, scope: :wiki_id

	def get_collaborator(wiki, user)
		wiki.collaborators.where(user_id: user.id).first
	end
end
