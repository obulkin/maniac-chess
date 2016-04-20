class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def do_omniauth
    @user = User.from_omniauth(request.env["omniauth.auth"])
    provider_data = @user.provider
    provider_kind = @user.provider.capitalize

    if @user.provider == "google_oauth2"
      provider_kind = "Google"
    end

    if @user.persisted?
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: "#{provider_kind}")
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.#{provider_data}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  alias_method :facebook, :do_omniauth
  alias_method :google_oauth2, :do_omniauth

  def failure
    flash[:alert] = "Could not authenticate."
    redirect_to root_path
  end
end
