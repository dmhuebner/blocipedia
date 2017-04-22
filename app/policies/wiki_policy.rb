class WikiPolicy < ApplicationPolicy

	def new?
		@user
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
end
