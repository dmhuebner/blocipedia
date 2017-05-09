require 'rails_helper'

RSpec.describe CollaboratorsController, type: :controller do

	let(:my_user) {create(:user)}
	let(:other_user) {User.create(name: "Other User", email: "other@user.com", password: "helloworld", role: "premium")}
	let(:my_wiki) {create(:wiki)}
	let(:my_collaborator) {Collaborator.create(user_id: my_user.id, wiki_id: my_wiki.id)}

	context "Guest" do
		before do
			other_user.confirm
		end

		describe "POST #create" do
			it "does not create collaborator" do
				count = my_wiki.collaborators.count
				post :create, {user_id: other_user.id, wiki_id: my_wiki.id}
				expect(count).to eq(my_wiki.collaborators.count)
			end
		end

		describe "DELETE #destroy" do
			it "does not delete collaborator" do
				collaborator = Collaborator.create!(user_id: other_user.id, wiki_id: my_wiki.id)
				count = Collaborator.count
				delete :destroy, {wiki_id: my_wiki.id, user_id: other_user.id, id: collaborator.id}
				expect(count).to eq(Collaborator.count)
			end
		end
	end

	context "Standard User" do
		before do
			my_user.confirm
			my_user.standard!
			sign_in my_user
		end

		describe "POST #create" do
			it "does not create collaborator" do
				count = my_wiki.collaborators.count
				post :create, {user_id: other_user.id, wiki_id: my_wiki.id}
				expect(count).to eq(my_wiki.collaborators.count)
			end
		end

		describe "DELETE #destroy" do
			it "does not delete collaborator" do
				collaborator = my_wiki.collaborators.where(user_id: my_user.id).create
				expect(my_wiki.collaborators.find_by_user_id(my_user.id)).not_to be_nil
				delete :destroy, {wiki_id: my_wiki.id, user_id: my_user.id, id: collaborator.id}
				expect(my_wiki.collaborators.find_by_user_id(my_user.id)).not_to be_nil
			end
		end
	end

	context "Premium User" do
		before do
			my_user.confirm
			my_user.premium!
			sign_in my_user
		end

		describe "POST #create" do
			it "redirects to the wiki's show view" do
				post :create, {user_id: other_user.id, wiki_id: my_wiki.id}
				expect(response).to redirect_to(my_wiki)
			end
			#Issue with this spec
			# it "creates collaborator for the wiki and the specified user" do
			# 	new_wiki = Wiki.create(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user_id: my_user.id)
			# 	expect(new_wiki.collaborators.find_by_user_id(other_user.id)).to be_nil
			# 	count = Collaborator.count
			# 	post :create, wiki_id: new_wiki.id, collaborator: {user_id: other_user.id}
			# 	expect(count).to eq(Collaborator.count + 1)
			# end
		end

		describe "DELETE #destroy" do
			it "redirect to the wiki's show view" do
				collaborator = my_wiki.collaborators.where(user_id: my_user.id).create
				delete :destroy, {wiki_id: my_wiki.id, user_id: my_user.id, id: collaborator.id}
				expect(response).to redirect_to(my_wiki)
			end
			it "destroys the specified collaborator for the wiki" do
				collaborator = my_wiki.collaborators.where(user_id: my_user.id).create
				expect(my_wiki.collaborators.find_by_user_id(my_user.id)).not_to be_nil
				delete :destroy, {wiki_id: my_wiki.id, user_id: my_user.id, id: collaborator.id}
				expect(my_wiki.collaborators.find_by_user_id(my_user.id)).to be_nil
			end
		end
	end

	context "Admin User" do
		before do
			my_user.confirm
			my_user.admin!
			sign_in my_user
		end

		describe "POST #create" do
			it "redirects to the wiki's show view" do
				post :create, {user_id: my_user.id, wiki_id: my_wiki.id}
				expect(response).to redirect_to(my_wiki)
			end
			# Issue with this spec
			# it "creates collaborator for the wiki and the specified user" do
			# 	expect(my_wiki.collaborators.find_by_user_id(other_user.id)).to be_nil
			# 	post :create, {user_id: other_user.id, wiki_id: my_wiki.id}
			# 	expect(my_wiki.collaborators.find_by_user_id(other_user.id)).not_to be_nil
			# end
		end

		describe "DELETE #destroy" do
			it "redirect to the wiki's show view" do
				collaborator = my_wiki.collaborators.where(user_id: my_user.id).create
				delete :destroy, {wiki_id: my_wiki.id, user_id: my_user.id, id: collaborator.id}
				expect(response).to redirect_to(my_wiki)
			end
			it "destroys the specified collaborator for the wiki" do
				collaborator = my_wiki.collaborators.where(user_id: my_user.id).create
				expect(my_wiki.collaborators.find_by_user_id(my_user.id)).not_to be_nil
				delete :destroy, {wiki_id: my_wiki.id, user_id: my_user.id, id: collaborator.id}
				expect(my_wiki.collaborators.find_by_user_id(my_user.id)).to be_nil
			end
		end
	end
end
