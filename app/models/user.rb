class User < ApplicationRecord
  has_many :projects

  devise :database_authenticatable, :registerable,
         :validatable, :rememberable
end
