## Wikiport 
### SUMMARY

Wikiport is a Wikipedia-like application built with Ruby on Rails. Its designed to let users post and share Markdown wikis. Users can sign up for a free account to post and edit public wikis. Users can also upgrade to a Premium Account which allows them to create private wikis and add other users as collaborators.

#### TECHNOLOGIES USED

**Ruby, Ruby on Rails, HTML5, CSS3, JavaScript, Git**

View the app: http://sheltered-stream-78255.herokuapp.com/

View the project http://github.com/dmhuebner/blocipedia

-----------------------------------------------------------------

#### EXPLANATION

The goal of this project was to build an application modeled after Wikipedia to practice and demonstrate my proficiency building CRUD applications with Ruby on Rails. It was created according to user stories provided in the Bloc Full Stack Developer curriculum.

Wikiport features user authentication via the robust Devise gem and authorization using the Pundit gem. Guest users can read through public wikis. Users can sign up for a free account to be able to edit and create their own public wikis. Users can upgrade to a Premium Account which allows them to create private wikis and add other users as collaborators. Wikiport integrates secure payments using the Stripe API.

-----------------------------------------------------------------

### Setup and Configuration
**Ruby v. 2.2.4**
**Rails v. 4.2.5**
**Databases:** SQLite (Test, Development), PostgreSQL (Production)

**Gems Used:**
- Bootstrap - Styling
- Devise - User authentication
- Factory Girl - Testing/development
- Figaro - Environment variables
- jQuery - JavaScript library
- Pundit - User authorization
- RedCarpet - Markdown syntax
- Rspec - Testing
- Shoulda - Relational/validation testing

**Set-up:**
- Environmental variables are secured with the Figaro gem and must be set up in config/application.yml (ignored by github)
- The config/application.example.yml demonstrates the necessary environment variables setup.

**To run locally:**
- Clone repository
- Run bundle install
- Create and migrate the SQLite database with rake db:create and rake db:migrate
- Start the Rails server
