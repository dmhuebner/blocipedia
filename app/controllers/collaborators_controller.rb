class CollaboratorsController < ApplicationController
  def create
		wiki = Wiki.find(params[:wiki_id])
		collab_user = find_user(params[:user_id])
		# collab_user = User.find(params[:user_id])
		# collaborator = Collaborator.create(user_id: params[:user_id], wiki_id: params[:wiki_id])
		collaborator = wiki.collaborators.build(user_id: params[:user_id])

		if collaborator.save
			flash[:notice] = "#{collab_user.name} (#{collab_user.email}) has been added as a collaborator for the \"#{wiki.title}\" wiki."
		else
			flash[:alert] = "There was a problem adding #{collab_user} as a collaborator for the \"#{wiki.title}\" wiki. Please try again."
		end
		redirect_to(wiki)
  end

  def destroy
		wiki = Wiki.find(params[:wiki_id])
		collaborator = wiki.collaborators.find(params[:id])

		if collaborator.destroy
			flash[:notice] = "#{collab_user.name} (#{collab_user.email}) is no longer a collaborator for the \"#{wiki.title}\" wiki."
		else
			flash[:alert] = "There was a problem removing #{collab_user.name} as a collaborator for the \"#{wiki.title}\" wiki. Please try again."
		end
		redirect_to(wiki)
  end

	private
	def find_user(user_id)
		users = User.all
		user = nil
		users.each do |u|
			if u.id == user_id
				user = u
			end
		end
		return user
	end
end
