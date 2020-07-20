class TaskDecorator < Draper::Decorator
  delegate_all

  def status
    if is_done
      'Done'
    else
      time_left.positive? ? set_time : 'Time is out'
    end
  end

  def time_class
    if is_done
      'bg-success'
    elsif time_left > 86_400
      'bg-dark'
    elsif time_left > 3600
      'bg-warning'
    else
      'bg-danger'
    end
  end

  private

  def time_left
    object.deadline - Time.zone.now
  end

  def set_time
    arr = []
    if time_left > 86_400
      arr.push(86_400, 'day')
    elsif time_left > 3600
      arr.push(3600, 'hour')
    else
      arr.push(60, 'minute')
    end
    h.pluralize((time_left / arr[0]).round, arr[1]) + ' left'
  end
end
