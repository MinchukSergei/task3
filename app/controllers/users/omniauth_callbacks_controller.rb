class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    create
  end

  def twitter
    create
  end

  def vkontakte
    create
  end

  def github
    create
  end

  private

    def create
      auth_params = request.env["omniauth.auth"]
      provider = AuthenticationProvider.where(name: auth_params.provider).first
      authentication = provider.user_authentications.where(uid: auth_params.uid).first
      existing_user = current_user || User.where(provider: auth_params.provider, uid: auth_params.uid).first_or_create do |user|
        user.email = "#{auth_params.provider}@gmail.com"
        user.password = Devise.friendly_token[0,20]
        user.name = auth_params['info']['name'] || auth_params['info']['nickname']
        user.provider = auth_params.provider
        user.uid = auth_params.uid
      end

      if authentication
        if existing_user.present? && existing_user.banned?
          flash[:alert] =  "You are banned!"
          redirect_to root_path
        else
          sign_in_with_existing_authentication(authentication)
        end
      elsif existing_user
        create_authentication_and_sign_in(auth_params, existing_user, provider)
      else
        create_user_and_authentication_and_sign_in(auth_params, provider)
      end
    end

    def sign_in_with_existing_authentication(authentication)
      sign_in_and_redirect(:user, authentication.user)
    end

    def create_authentication_and_sign_in(auth_params, user, provider)
      UserAuthentication.create_from_omniauth(auth_params, user, provider)

      sign_in_and_redirect(:user, user)
    end

    def create_user_and_authentication_and_sign_in(auth_params, provider)
      user = User.create_from_omniauth(auth_params)
      if user.valid?
        create_authentication_and_sign_in(auth_params, user, provider)
      else
        flash[:error] = user.errors.full_messages.first
        redirect_to new_user_registration_url
      end
    end
end
