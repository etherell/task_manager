class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :user, :project, :position, :deadline, presence: true
  validates :position, uniqueness: { scope: :project }, unless: :skip_position_validation
  validates :description, length: { in: 3..255 }
  validate  :deadline_after_now?, unless: :skip_deadline_validation

  attr_accessor :skip_deadline_validation, :skip_position_validation

  def done!
    self.skip_deadline_validation = true
    update(is_done: true)
  end

  def not_done!
    self.skip_deadline_validation = true
    update(is_done: false)
  end

  private

  def deadline_after_now?
    return if deadline.nil?

    errors.add :deadline, "can't be in the past" if deadline.to_datetime < Time.zone.now
  end
end
