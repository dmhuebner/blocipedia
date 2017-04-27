class CollaboratorsController < ApplicationController
  def create
		wiki = Wiki.find(params[:wiki_id])
		collab_user = User.find(params[:user_id])
		collaborator = wiki.collaborators.build(user: collab_user)

		if collaborator.save
			flash[:notice] = "#{collab_user.name} (#{collab_user.email}) has been added as a collaborator for the \"#{wiki.title}\" wiki."
		else
			flash[:alert] = "There was a problem adding #{collab_user.name} as a collaborator for the \"#{wiki.title}\" wiki. Please try again."
		end
		redirect_to(wiki)
  end

  def destroy
		wiki = Wiki.find(params[:wiki_id])
		collaborator = wiki.collaborators.find(params[:id])

		if collaborator.destroy
			flash[:notice] = "#{collaborator.user.name} (#{collaborator.user.email}) is no longer a collaborator for the \"#{wiki.title}\" wiki."
		else
			flash[:alert] = "There was a problem removing #{collaborator.user.name} as a collaborator for the \"#{wiki.title}\" wiki. Please try again."
		end
		redirect_to(wiki)
  end
end
