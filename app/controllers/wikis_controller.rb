class WikisController < ApplicationController
	# before_action :authenticate_user!

  def index
		@wikis = Wiki.all
		authorize @wikis
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
		authorize @wiki
  end

	def create
		@wiki = Wiki.new(wiki_params)
		authorize @wiki
		@wiki.user = current_user

		if @wiki.save
			flash[:notice] = "Wiki was saved successfully."
			redirect_to @wiki
		else
			flash[:alert] = "There was an error saving the wiki. Please try again."
			render :new
		end
	end

	def update
		@wiki = Wiki.find(params[:id])
		authorize @wiki
		@wiki.assign_attributes(wiki_params)

		if @wiki.save
			flash[:notice] = "\"#{@wiki.title}\" wiki was updated successfully."
			redirect_to @wiki
		else
			flash[:alert] = "There was an erroring saving the updates to the #{@wiki.title} wiki. Please try again."
			render :edit
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
		params.require(:wiki).permit(:title, :body, :public, :user_id)
	end
end
