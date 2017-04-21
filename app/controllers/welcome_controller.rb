class WelcomeController < ApplicationController
  def index
		if current_user
			redirect_to :wikis
		end
  end

  def about
  end
end
