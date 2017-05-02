class CollaboratorPolicy < ApplicationPolicy
	def create?
		@user && !@user.standard? && @record.user == @user
	end

	def destroy?
		@user && !@user.standard? && @record.user == @user
	end
end
