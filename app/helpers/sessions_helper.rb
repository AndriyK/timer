module SessionsHelper

  # Function sigh in user, by setting cookie[:remember_tocken]
  #
  # * *Args*    :
  #   - +user+ User object-> user that should be sighned in
  # * *Returns* :
  #   nothing (set self.current_user)
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  # Function sigh out user, by deleting cookie[:remember_tocken]
  #
  # * *Args*    :
  #   - +user+ User object-> user that should be sighned in
  # * *Returns* :
  #   nothing (set self.current_user to nul)
  def sign_out
    cookies.delete(:remember_token)
    session.clear
    self.current_user = nil
  end

  # Function set instance variable @current_user to passed user
  #
  # * *Args*    :
  #   - +user+ User object-> user that should be saved
  # * *Returns* :
  #   nothing (set instance variable)
  def current_user=(user)
    @current_user = user
  end

  # Function return current user (instance variable @current_user / or trying create new one from cookie)
  #
  # * *Args*    :
  #   no
  # * *Returns* :
  #   user
  def current_user
    @current_user ||= user_from_remember_token
  end

  # Function checks if use signed in
  #
  # * *Args*    :
  #   no
  # * *Returns* :
  #   true/false
  def signed_in?
    !current_user.nil?
  end

  # Function checks passed user is current user
  #
  # * *Args*    :
  #   - +user+ User object-> user for check
  # * *Returns* :
  #   true/false
  def current_user?(user)
    user == current_user
  end

  # Function authenticates user for individual resources
  #
  # * *Args*    :
  #   no
  # * *Returns* :
  #   nothing / redirect to sign in page for unsigned users
  def authenticate
    deny_access unless signed_in?
  end

  # Function redirect user to sign in page
  #
  # * *Args*    :
  #   no
  # * *Returns* :
  #   nothing (redirect)
  def deny_access
    store_location
    redirect_to login_path, :notice => "Please sign in to access this page."
  end

  # Function redirect user to previous or default page
  #
  # * *Args*    :
  #   - +default+ string  - page for defualt redirect
  # * *Returns* :
  #   nothing (redirect)
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  # Function store current user location
  #
  # * *Args*    :
  #   no
  # * *Returns* :
  #   nothing (set session[:return_to] variable)
  def store_location
    session[:return_to] = request.fullpath
  end



  private

    # Function authenticate user with token
    #
    # * *Args*    :
    #   no
    # * *Returns* :
    #   true/false
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    # Function return user's token from cookie if such set
    #
    # * *Args*    :
    #   no
    # * *Returns* :
    #   remembered_token or nil
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

    # Function set session element :return_to to Nil
    #
    # * *Args*    :
    #   no
    # * *Returns* :
    #   nothing (set session[:return_to] variable)
    def clear_return_to
      session[:return_to] = nil
    end

end
