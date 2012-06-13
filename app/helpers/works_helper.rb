module WorksHelper

  include RoutinesHelper

  # Function return the amount of days in defined month
  #
  # * *Args*    :
  #   - +date+ date object-> date for which month amount of days is required
  # * *Returns* :
  #   integer amount of days in month
  def get_days_in_month date
    months = { 1=>31, 2=>(Date.leap?(date.year) ? 29 :28), 3=>31, 4=>30, 5=>31, 6=>30, 7=>31, 8=>31, 9=>30, 10=>31, 11=>30, 12=>31}
    months[date.mon]
  end

  # Function extract time part from date
  #
  # * *Args*    :
  #   - +date+ date object-> current date
  # * *Returns* :
  #   string representation of the time = "9:00"
  def get_time_part date
    date.strftime("%k:%M")
  end

  # Function humanize duration of the work for the report
  #
  # * *Args*    :
  #   - +duration+ integer-> amount of minutes spent for work
  # * *Returns* :
  #   string representation of the  spent time = "1 h 20 min"
  def humanize_duration duration
    if duration < 60
      return duration.to_s + ' min'
    else
      hour = duration/60
      min = duration - 60*hour
      return hour.to_s + ' h ' + (( min > 0 ) ? (min.to_s + ' min') : '')
    end
  end

  # Function return the date for previous day of provided date
  #
  # * *Args*    :
  #   - +date+ date object-> current date
  # * *Returns* :
  #   string representation of date = "2012-06-12"
  def day_before( date )
    (date - 1.day).strftime("%Y-%m-%d")
  end

  # Function return the date for next day of provided date
  #
  # * *Args*    :
  #   - +date+ date object-> current date
  # * *Returns* :
  #   string representation of date = "2012-06-12"
  def day_after( date )
    (date + 1.day).strftime("%Y-%m-%d")
  end

  # Function return the name for cell of the time line builded from date (time is used)
  #
  # * *Args*    :
  #   - +date+ date object-> current date
  # * *Returns* :
  #   integer value (amount of minuted from midnight, for time 1:20 it would be 80)
  def get_name_for_timeline date
    date.hour*60 + date.min
  end

end
