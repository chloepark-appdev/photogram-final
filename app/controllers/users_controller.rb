class UsersController < ApplicationController
  def index
    matching_users = User.all

    @list_of_users = matching_users.order({ :created_at => :desc })

    render({ :template => "users/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_users = User.where({ :id => the_id })

    @the_user = matching_users.at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    the_user = User.new
    the_user.email = params.fetch("query_email")
    the_user.password_digest = params.fetch("query_password_digest")
    the_user.private = params.fetch("query_private", false)
    the_user.username = params.fetch("query_username")
    the_user.password = params.fetch("query_password")

    if the_user.valid?
      the_user.save
      redirect_to("/users", { :notice => "User created successfully." })
    else
      redirect_to("/users", { :notice => "User failed to create successfully." })
    end
  end

  def sign_up_form
    render({ :template => "users/sign_up.html.erb" })
  end

  def sign_in_form
    render({ :template => "users/sign_in.html.erb" })
  end

  def update

    the_user = @current_user

    # the_user.comments_count = params.fetch("query_comments_count")
    the_user.email = params.fetch("query_email")
    # the_user.likes_count = params.fetch("query_likes_count")
    the_user.password_digest = params.fetch("query_password_digest")
    the_user.private = params.fetch("query_private", false)
    the_user.username = params.fetch("query_username")
    the_user.password = params.fetch("query_password")

    if the_user.valid?
      the_user.save
      redirect_to("/users/#{the_user.id}", { :notice => "User updated successfully."} )
    else
      redirect_to("/users/#{the_user.id}", { :alert => "User failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_user = User.where({ :id => the_id }).at(0)

    the_user.destroy

    redirect_to("/users", { :notice => "User deleted successfully."} )
  end

  def create_cookie
    user = User.where({ :email => params.fetch("query_email") }).first
    
    the_supplied_password = params.fetch("query_password")
    
    if user != nil
      are_they_legit = user.authenticate(the_supplied_password)
    
      if are_they_legit == false
        redirect_to("/user_sign_in", { :alert => "Incorrect password." })
      else
        session[:user_id] = user.id
      
        redirect_to("/", { :notice => "Signed in successfully." })
      end
    else
      redirect_to("/user_sign_in", { :alert => "No user with that email address." })
    end
  end

  def destroy_cookies
    reset_session

    redirect_to("/", { :notice => "Signed out successfully." })
  end

  def edit_profile_form
    render({ :template => "users/edit_profile.html.erb" })
  end

end
