class User < ActiveRecord::Base
	has_many :wikis, dependent: :destroy

	validates :name, length: {minimum: 1, maximum: 100}, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
end
