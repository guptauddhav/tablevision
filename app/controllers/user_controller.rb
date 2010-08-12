class UserController < ApplicationController
  
  before_filter :login_required, :only=> [:new_password, :delete]
  
  ## Creating a new user.
  #
  def new
    if request.post?
      @user = User.new(params[:user])
      @user.ip_address = ip_address
      if @user.save
        flash[:notice] = "Signup successful. Activation e-mail has been sent."
        redirect_to(:controller => "login", :action => "login")
      else
        flash[:warning] = "Please try again - problems saving your details to 
                          the database"
        render(:action => "new")
      end
    end
  end
  
  # Activating a user.
  #
  def activate
    unless params[:activation_id].blank?
      user = User.find(:first, :conditions => 
                      {:activation_id => params[:activation_id]}) 
    end 
    
    # check activation id is valid and if not show error.
    case
    when (!params[:activation_id].blank?) && user && !user.active?
      user.activate!
      self.current_user = user
      flash[:notice] = "Account Activated."
      #redirect_to dashboard_url
      puts "Account Activated."
    when params[:activation_id].blank?
      flash[:error] = "The activation code was missing. Please follow the URL 
                      from your email."
      #redirect_back_or_default('/')
      puts "Blank Activation code."
    else
      flash[:error] = "We couldn't find a user with that activation code -- 
                      check your email? Or maybe you've already activated -- 
                      try signing in."
      #redirect_back_or_default('/')
      puts "Invalid Activation code."
    end
  end
  
  
  def forgot_password
    # Just show a form with an email field.
  end
  
  def send_password_reset
    if @user = User.find(:first, :conditions => {:email => params[:email]})
      flash.now[:notice] = "Password reset instructions sent."
      @user.make_reset_token
      puts @user.reset_token
      if @user.save(false)
        @user.send_password_reset_mail
      else
        #TODO: redirect to internal error page.
        flash.now[:error] = "Could not save user with that email address."
        respond_to do |page|
          page.html { render :action => 'forgot_password' }
        end
      end
      
    else
      flash.now[:error] = "Could not find a user with that email address."
      respond_to do |page|
        page.html { render :action => 'forgot_password' }
      end
    end
  end
  
  def reset_password
    if params[:reset_token].present?
      unless @user = User.find(:first, 
                               :conditions => {:reset_token => params[:reset_token]})
        flash[:error] = "Could not find a user with that passowrd reset token, 
                        Please follow the URL from your email."
        #redirect_to root_url
        puts "Invalid Password Token"
      end
    else
      flash[:error] = "Could not find a user with that passowrd reset token, 
                      Please follow the URL from your email."
      #redirect_to root_url
      puts "Invalid Password Token"
    end
  end
  
  
  def update_password
    if @user = User.find(:first, 
                         :conditions => {:reset_token => params[:reset_token]})
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      @user.clear_reset_token
      if @user.save(false)
        flash[:notice] = "Your password was updated successfully, 
                         Please login using your new password"
        #respond_to do |page|
        #  page.html { redirect_to login_url }
        #end
        puts "Reset password."
      else
        respond_to do |page|
          page.html { render :action => 'reset_password' }
        end
      end
    end
  end
  
end
