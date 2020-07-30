class User < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :validatable, :rememberable
end
