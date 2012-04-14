module UsersHelper

  def get_time_part date
    time = date.hour.to_s + ":"
    if date.min == 0
      time + '00'
    else
      time + date.min.to_s
    end
  end

  def humanize_duration duration
    if duration < 60
      return duration.to_s + ' min'
    else
      hour = duration/60
      min = duration - 60*hour
      return hour.to_s + ' h ' + (( min > 0 ) ? (min.to_s + ' min') : '')
    end
  end

  def day_before( date )
    date - 60*60*24
  end

  def day_after( date )
    date + 60*60*24
  end

  def get_name_for_timeline date
    date.hour*60 + date.min
  end

end
