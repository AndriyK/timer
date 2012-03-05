class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

=begin
  before_filter :set_timezone
  def set_timezone
    Time.zone = 'GMT'
  end
=end
end
