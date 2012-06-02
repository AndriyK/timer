module WorksHelper

  include RoutinesHelper
=begin
  def week_before current_start_week
    wdate = Date.commercial(2012, current_week, 1)
    wdate = wdate - 1.week
    wdate.cweek
  end

  def week_after current_week
    wdate = Date.commercial(2012, current_week, 1)
    wdate = wdate + 1.week
    wdate.cweek
  end
=end
end
