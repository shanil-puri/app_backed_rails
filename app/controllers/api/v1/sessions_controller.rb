class Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  # The sessions controller has two actions: create for login and destroy for logout.
  # The first accepts a user JSON object as POST data with an email and a password parameters and returns an auth_token
  # if the user exists in the database and the password is correct. The logout action expects an auth_token parameter in the url.
  def create
    respond_to do |format|
      format.html { super }
      format.json {
        warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
        render :status => 200,
               :json => { :success => true,
                          :info => "Logged in",
                          :data => { :auth_token => current_user.authentication_token, :roles => current_user.roles }}
      }
    end
  end

  def destroy
    warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    current_user.update_column(:authentication_token, nil)
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :data => {} }
  end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
  end
end