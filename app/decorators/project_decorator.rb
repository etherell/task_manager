class ProjectDecorator < Draper::Decorator
  delegate_all
  decorates_association :task
end
