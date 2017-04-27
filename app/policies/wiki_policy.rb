class WikiPolicy < ApplicationPolicy

	def new?
		@user
	end

	def show?
		permit = false
		if @record.private == true
			if (@user.role == 'premium' && @record.user == @user) || @user.role == 'admin'
				permit = true
			else
				@record.collaborators.each do |c|
					if c.user_id == @user.id
						permit = true
					end
				end
			end
		else
			permit = true
		end
		return permit
	end

	def create?
		@user
	end

	def update?
		@user
	end

	def destroy?
		@user && @record.user_id == @user.id
	end

	class Scope
		attr_reader :user, :scope

		def initialize(user, scope)
			@user = user
			@scope = scope
		end

		def resolve
			wikis = []
			if user != nil && user.role == 'admin'
				wikis = scope.all # if the user is an admin, show them all the wikis
			elsif user != nil && user.role == 'premium'
				all_wikis = scope.all
				all_wikis.each do |wiki|
					if wiki.private? == false || wiki.user == user || wiki.collaborators.include?(user)
						wikis << wiki # if the user is premium, only show them public wikis, or that private wikis they created, or private wikis they are a collaborator on
					end
				end
			else # this is the lowly standard user
				all_wikis = scope.all
				wikis = []
				all_wikis.each do |wiki|
					if wiki.private? == false || wiki.collaborators.include?(user)
						wikis << wiki # only show standard users public wikis and private wikis they are a collaborator on
					end
				end
			end
			wikis # return the wikis array we've built up
		end
	end
end
