class MainController < ApplicationController

  before_filter :redirect_user, :only => [:home]

  def home
    @title = 'Home'
  end

  def about
    @title = 'About timer'
  end

  def contact
    @title = 'Contacts'
  end


  private

    def redirect_user
      redirect_to work_path(current_user) if signed_in?
    end

end
