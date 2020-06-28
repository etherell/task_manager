class Project < ApplicationRecord
  validates :title, length: { in: 3..50 }
  validates :user, presence: true

  belongs_to :user
end
