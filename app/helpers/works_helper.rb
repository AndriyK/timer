module WorksHelper

  include RoutinesHelper

  def get_days_in_month date
    months = { 1=>31, 2=>(Date.leap?(date.year) ? 29 :28), 3=>31, 4=>30, 5=>31, 6=>30, 7=>31, 8=>31, 9=>30, 10=>31, 11=>30, 12=>31}
    months[date.mon]
  end
end
