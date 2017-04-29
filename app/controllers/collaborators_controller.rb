class CollaboratorsController < ApplicationController
  def create
		wiki = Wiki.find(params[:wiki_id])
		collab_user = User.find_by_email(params[:email])

		# Make collaborator if collab_user exists
		if collab_user.present?
			collaborator = wiki.collaborators.build(user_id: collab_user.id)
		end

		if wiki.private
			if collaborator && collaborator.save
				flash[:notice] = "#{collab_user.name} (#{collab_user.email}) has been added as a collaborator for the \"#{wiki.title}\" wiki."
			else
				flash[:alert] = "There was a problem adding that user as a collaborator. Please double check the email and try again."
			end
		else
			flash[:alert] = "This wiki is not private. It must be private to add collaborators."
		end
		redirect_to(wiki)
  end

  def destroy
		wiki = Wiki.find(params[:wiki_id])
		collab_user = User.find_by_email(params[:email])

		# Make collaborator if collab_user exists
		if collab_user.present?
			collaborator = wiki.collaborators.find(params[:id])
		end

		if collaborator && collaborator.destroy
			flash[:notice] = "#{collab_user.name} (#{collab_user.email}) is no longer a collaborator for the \"#{wiki.title}\" wiki."
		else
			flash[:alert] = "There was a problem removing that user as a collaborator for the \"#{wiki.title}\" wiki. Please check the email and try again."
		end
		redirect_to(wiki)
  end
end
