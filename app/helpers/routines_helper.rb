module RoutinesHelper

  def humanize_days days
      days.gsub(/[1234567]/, '1' => 'Mon', '2' => 'Tue', '3' => 'Wed', '4'=>'Thu', '5'=>'Fri', '6'=>'Sut', '7'=>'Sun') if days
  end

  def humanize_weeks weeks
    weeks.gsub(/[1234]/, '1' => 'First', '2' => 'Second', '3' => 'Third', '4'=>'Forth') if weeks
  end

end
