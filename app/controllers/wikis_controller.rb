class WikisController < ApplicationController
	# before_action :authenticate_user!

  def index
		# Pundit Wiki Policy Scope
		@wikis = policy_scope(Wiki)
		# @wikis = Wiki.all
		# authorize @wikis
  end

	def my_wikis
		@user = current_user
	end

  def show
		@wiki = Wiki.find(params[:id])
		authorize @wiki
  end

  def new
		@wiki = Wiki.new
		authorize @wiki
  end

  def edit
		@wiki = Wiki.find(params[:id])
		#redirect to new_user_registration_path if no current_user
		# if !current_user
		# 	redirect_to(new_user_registration_path)
		# end
		authorize @wiki
		@collaborators = @wiki.collaborators
		# @collaborator = @wiki.collaborators.find_by_user_id(params[:user_id])
		# @collab_to_remove = @wiki.collaborator(user_id)
  end

	def create
		@wiki = Wiki.new(wiki_params)
		authorize @wiki
		@wiki.user = current_user

		if @wiki.private && @wiki.user.standard?
			flash[:alert] = "You need a Premium account to make your Wiki private."
			render :new
		else
			if @wiki.save
				flash[:notice] = "Wiki was saved successfully."
				redirect_to @wiki
			else
				flash[:alert] = "There was an error saving the wiki. Please try again."
				render :new
			end
		end
	end

	def update
		@wiki = Wiki.find(params[:id])
		authorize @wiki
		@wiki.assign_attributes(wiki_params)

		if @wiki.private && @wiki.user.standard?
			flash[:alert] = "You need a Premium account to make your Wiki private."
			render :edit
		else
			if @wiki.save
				flash[:notice] = "\"#{@wiki.title}\" wiki was updated successfully."
				redirect_to @wiki
			else
				flash[:alert] = "There was an erroring saving the updates to the #{@wiki.title} wiki. Please try again."
				render :edit
			end
		end
	end

	def destroy
		@wiki = Wiki.find(params[:id])
		authorize @wiki

		if @wiki.destroy
			flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
			redirect_to wikis_path
		else
			flash[:alert] = "There was an error deleting the \"#{@wiki.title}\" wiki. Please try again."
			render :show
		end
	end

	private
	def wiki_params
		params.require(:wiki).permit(:title, :body, :private, :user_id)
	end
end
