class Project < ApplicationRecord
  validates :title, length: { in: 3..75 }
  validates :user, presence: true

  belongs_to :user
  has_many :tasks, dependent: :destroy

  def last_task_position
    tasks.maximum(:position)
  end
end
