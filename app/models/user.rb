class User < ActiveRecord::Base
	has_many :wikis, dependent: :destroy
	has_many :collaborators
	# has_many :wikis, through: :collaborators

	before_save { self.role ||= :standard}

	validates :name, length: {minimum: 1, maximum: 100}, presence: true

	enum role: [:standard, :premium, :admin]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
end
