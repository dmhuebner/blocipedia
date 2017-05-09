class CollaboratorPolicy < ApplicationPolicy
	def create?
		@user && @user.standard? == false && @user.wikis.find(@record.wiki_id)
	end

	def destroy?
		@user && @user.standard? == false && @user.wikis.find(@record.wiki_id)
	end
end
