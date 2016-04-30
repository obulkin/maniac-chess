class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def do_omniauth
    @user = User.from_omniauth(request.env["omniauth.auth"])
    provider_data = @user.provider
    provider_kind = @user.provider.capitalize

    if @user.persisted?
      flash[:notice] = I18n.t("devise.omniauth_callbacks.success", kind: "#{provider_kind}")
      sign_in_and_redirect @user, :event => :authentication
    else
      flash[:notice] = "We were not able to authenticate you. Try signing up directly with MANIAC chess by entering an email address and creating a new password."
      redirect_to new_user_registration_url
    end
  end

  alias_method :facebook, :do_omniauth
  alias_method :google, :do_omniauth

  def failure
    flash[:alert] = "Uh oh, looks like something went wrong! Please try again later or sign up with MANIAC Chess directly by providing an email address and password."
    redirect_to root_path
  end
end
