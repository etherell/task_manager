class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :user, presence: true
  validates :position, uniqueness: { scope: :project } # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :description, length: { in: 3..255 }
  validates :deadline, presence: true
  validate :deadline_after_now?

  def done!
    update(is_done: true)
  end

  def not_done!
    update(is_done: false)
  end

  private

  def deadline_after_now?
    return if deadline.nil?

    errors.add :deadline, "can't be in the past" if deadline.to_datetime < Time.zone.now
  end
end
