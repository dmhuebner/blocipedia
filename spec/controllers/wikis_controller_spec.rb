require 'rails_helper'

RSpec.describe WikisController, type: :controller do

	let(:my_user) {create(:user)}
	let(:my_wiki) {create(:wiki)}

	context "Guest" do
		describe "GET #index" do
			it "returns http success" do
				get :index
				expect(response).to have_http_status(:success)
			end
			it "renders the #index view" do
				get :index
				expect(response).to render_template(:index)
			end
			it "assigns my_wiki to @wikis" do
				get :index
				expect(assigns(:wikis)).to eq([my_wiki])
			end
		end

		describe "GET #show" do
			it "returns http success" do
				get :show, id: my_wiki.id
				expect(response).to have_http_status(:success)
			end
			it "renders the #show view" do
				get :show, id: my_wiki.id
				expect(response).to render_template(:show)
			end
			it "assigns my_wiki to @wiki" do
				get :show, id: my_wiki.id
				expect(assigns(:wiki)).to eq(my_wiki)
			end
		end

		describe "GET #new" do
			it "redirects to new registration view" do
				get :new
				expect(response).to have_http_status(:redirect)
			end
		end

		describe "POST create" do
			it "redirects to new registration view" do
				post :create, wiki: {title: my_wiki.title, body: my_wiki.body}
				expect(response).to have_http_status(:redirect)
			end
		end

		describe "GET edit" do
			it "redirects to new registration view" do
				get :edit, id: my_wiki.id
				expect(response).to have_http_status(:redirect)
			end
		end

		describe "PUT update" do
			it "redirects to new registration view" do
				new_title = RandomData.random_sentence
				new_body = RandomData.random_paragraph
				put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
				expect(response).to have_http_status(:redirect)
			end
		end

		describe "DELETE destroy" do
			it "redirects to new registration view" do
				delete :destroy, id: my_wiki.id
				expect(response).to have_http_status(:redirect)
			end
		end
	end

	context "Standard User" do
		before do
			my_user.confirm
			my_user.standard!
			sign_in my_user
		end

	  describe "GET #index" do
	    it "returns http success" do
	      get :index
	      expect(response).to have_http_status(:success)
	    end
			it "renders the #index view" do
				get :index
				expect(response).to render_template(:index)
			end
			it "assigns my_wiki to @wikis" do
				get :index
				expect(assigns(:wikis)).to eq([my_wiki])
			end
	  end

	  describe "GET #show" do
	    it "returns http success" do
	      get :show, id: my_wiki.id
	      expect(response).to have_http_status(:success)
	    end
			it "renders the #show view" do
				get :show, id: my_wiki.id
				expect(response).to render_template(:show)
			end
			it "assigns my_wiki to @wiki" do
				get :show, id: my_wiki.id
				expect(assigns(:wiki)).to eq(my_wiki)
			end
	  end

	  describe "GET #new" do
	    it "returns http success" do
	      get :new
	      expect(response).to have_http_status(:success)
	    end
			it "renders the #new view" do
				get :new
				expect(response).to render_template(:new)
			end
			it "initializes @wiki" do
				get :new
				expect(assigns(:wiki)).not_to be_nil
			end
	  end

		describe "POST #create" do
			it "increases the number of wikis by 1" do
				expect{ post :create, {wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user_id: my_user.id}}}.to change(Wiki, :count).by(1)
			end
			it "assigns Wiki.last to @wiki" do
				post :create, {wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user_id: my_user.id}}
				expect(assigns(:wiki)).to eq(Wiki.last)
			end
			it "redirects to the new wiki" do
				post :create, {wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user_id: my_user.id}}
				expect(response).to redirect_to(Wiki.last)
			end
		end

	  describe "GET #edit" do
	    it "returns http success" do
	      get :edit, id: my_wiki.id
	      expect(response).to have_http_status(:success)
	    end
			it "renders the #edit view" do
				get :edit, id: my_wiki.id
				expect(response).to render_template(:edit)
			end
			it "assigns the wiki to be updated to @wiki" do
				get :edit, id: my_wiki.id
				wiki_instance = assigns(:wiki)
				expect(wiki_instance.id).to eq(my_wiki.id)
				expect(wiki_instance.title).to eq(my_wiki.title)
				expect(wiki_instance.body).to eq(my_wiki.body)
			end
	  end

		describe "PUT update" do
			it "updates wiki with expected attributes" do
				new_title = RandomData.random_sentence
				new_body = RandomData.random_paragraph
				put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
				updated_wiki = assigns(:wiki)
				expect(updated_wiki.id).to eq(my_wiki.id)
				expect(updated_wiki.title).to eq(new_title)
				expect(updated_wiki.body).to eq(new_body)
			end
			it "redirects to the updated wiki" do
				new_title = RandomData.random_sentence
				new_body = RandomData.random_paragraph
				put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
				expect(response).to redirect_to(my_wiki)
			end
		end

		describe "DELETE destroy" do
			it "user deletes their own wiki" do
				wiki = Wiki.create(title: "New Wiki Title", body: "New example wiki body", user_id: my_user.id)
				delete :destroy, id: wiki.id
				count = Wiki.where({id: wiki.id}).size
				expect(count).to eq(0)
			end
			it "redirects to wikis index" do
				wiki = Wiki.create(title: "New Wiki Title", body: "New example wiki body", user_id: my_user.id)
				delete :destroy, id: wiki.id
				expect(response).to redirect_to wikis_path
			end
		end

		describe "private wiki - unauthorized" do
			it "POST create - does not save private wiki" do
				count = Wiki.count
				post :create, {wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user_id: my_user.id, private: true}}
				expect(count).to eq(Wiki.count)
			end
			it "PUT update - does not update wiki" do
				new_title = RandomData.random_sentence
				new_body = RandomData.random_paragraph
				put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body, private: true}
				expect(my_wiki.private).not_to be_truthy
			end
		end
	end

	context "Premium User" do
		before do
			my_user.confirm
			my_user.premium!
			sign_in my_user
		end

		describe "GET #index" do
			it "returns http success" do
				get :index
				expect(response).to have_http_status(:success)
			end
			it "renders the #index view" do
				get :index
				expect(response).to render_template(:index)
			end
			it "assigns my_wiki to @wikis" do
				get :index
				expect(assigns(:wikis)).to eq([my_wiki])
			end
		end

		describe "GET #show" do
			it "returns http success" do
				get :show, id: my_wiki.id
				expect(response).to have_http_status(:success)
			end
			it "renders the #show view" do
				get :show, id: my_wiki.id
				expect(response).to render_template(:show)
			end
			it "assigns my_wiki to @wiki" do
				get :show, id: my_wiki.id
				expect(assigns(:wiki)).to eq(my_wiki)
			end
		end

		describe "GET #new" do
			it "returns http success" do
				get :new
				expect(response).to have_http_status(:success)
			end
			it "renders the #new view" do
				get :new
				expect(response).to render_template(:new)
			end
			it "initializes @wiki" do
				get :new
				expect(assigns(:wiki)).not_to be_nil
			end
		end

		describe "POST #create" do
			it "increases the number of wikis by 1" do
				expect{ post :create, {wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user_id: my_user.id}}}.to change(Wiki, :count).by(1)
			end
			it "assigns Wiki.last to @wiki" do
				post :create, {wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user_id: my_user.id}}
				expect(assigns(:wiki)).to eq(Wiki.last)
			end
			it "redirects to the new wiki" do
				post :create, {wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, user_id: my_user.id}}
				expect(response).to redirect_to(Wiki.last)
			end
		end

		describe "GET #edit" do
			it "returns http success" do
				get :edit, id: my_wiki.id
				expect(response).to have_http_status(:success)
			end
			it "renders the #edit view" do
				get :edit, id: my_wiki.id
				expect(response).to render_template(:edit)
			end
			it "assigns the wiki to be updated to @wiki" do
				get :edit, id: my_wiki.id
				wiki_instance = assigns(:wiki)
				expect(wiki_instance.id).to eq(my_wiki.id)
				expect(wiki_instance.title).to eq(my_wiki.title)
				expect(wiki_instance.body).to eq(my_wiki.body)
			end
		end

		describe "PUT update" do
			it "updates wiki with expected attributes" do
				new_title = RandomData.random_sentence
				new_body = RandomData.random_paragraph
				put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
				updated_wiki = assigns(:wiki)
				expect(updated_wiki.id).to eq(my_wiki.id)
				expect(updated_wiki.title).to eq(new_title)
				expect(updated_wiki.body).to eq(new_body)
			end
			it "redirects to the updated topic" do
				new_title = RandomData.random_sentence
				new_body = RandomData.random_paragraph
				put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body}
				expect(response).to redirect_to(my_wiki)
			end
		end

		describe "DELETE destroy" do
			it "user deletes their own wiki" do
				wiki = Wiki.create(title: "New Wiki Title", body: "New example wiki body", user_id: my_user.id)
				delete :destroy, id: wiki.id
				count = Wiki.where({id: wiki.id}).size
				expect(count).to eq(0)
			end
			it "redirects to wikis index" do
				wiki = Wiki.create(title: "New Wiki Title", body: "New example wiki body", user_id: my_user.id)
				delete :destroy, id: wiki.id
				expect(response).to redirect_to wikis_path
			end
		end

		describe "private wiki - authorized" do
			it "POST create - saves private wiki" do
				count = Wiki.count
				expect{post :create, {wiki: {title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true}}}.to change(Wiki, :count).by(1)
				expect(count + 1).to eq(Wiki.count)
			end
			it "PUT update - has http status success" do
				new_title = RandomData.random_sentence
				new_body = RandomData.random_paragraph
				put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body, private: true}
				expect(response).to have_http_status(:success)
			end
			it "PUT update - updates the wiki - sets private = true" do
				new_title = RandomData.random_sentence
				new_body = RandomData.random_paragraph
				put :update, id: my_wiki.id, wiki: {title: new_title, body: new_body, private: true}
				updated_wiki = assigns(:wiki)
				expect(updated_wiki.private).to eq(true)
			end
		end
	end
end
