module PandaCms
  module SessionHelpers
    # Create a user with the given provider
    #
    # @param provider [Symbol] The provider to create the user with
    # @param admin [Boolean] Whether the user should be an admin
    def create_user_with(provider, admin: false)
      info = OmniAuth.config.mock_auth[provider][:info]
      name_parts = info[:name].split(" ")

      PandaCms::Current.user = PandaCms::User.create!(
        admin: admin,
        email: info[:email],
        firstname: name_parts.first,
        lastname: name_parts.last,
        image_url: info[:image]
      )
    end

    # Creates and logs in a user with the specified provider.
    #
    # @param provider [String] The provider used to create the user.
    # @param admin [Boolean] (optional) Whether the user should be an admin. Default is false.
    # @return [User] The created user.
    def create_and_login_user_with(provider, admin: false)
      user = create_user_with(provider, admin: admin)
      login_as(user, provider: provider)
    end

    # Logs in a user with the specified provider.
    #
    # Parameters:
    # - user: The user to log in.
    # - provider: The authentication provider to use (default: :github).
    #
    # Example usage:
    #   login_as(user, provider: :github)
    #
    # This method sets up the OmniAuth mock authentication for the specified provider,
    # visits the "/admin" page, and sets the session cookie for the user. It also adds
    # the session cookie to the browser's cookie jar for Selenium, and clicks the sign-in
    # button for the specified provider.
    def login_as(user, provider: :github)
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[provider]
      visit "/admin"

      cookies = ActionDispatch::TestRequest.create.cookie_jar
      cookies.signed[:session_id] = {value: user.id, httpOnly: true, sameSite: :Lax}

      # For Selenium:
      # page.driver.browser.manage.add_cookie(
      #   name: "session_id",
      #   value: cookies[:session_id],
      #   sameSite: :Lax,
      #   httpOnly: true
      # )

      # For Capybara:
      # browser = Capybara.current_session.driver.browser
      # browser.manage.add_cookie :name => 'ab', :value => 'true', :expires => Time.now + 3600
      # page.driver.browser.manage.add_cookie(name: "session_id", value: cookie_jar[:session_id], sameSite: :Lax, httpOnly: true)
      # visit "/admin"

      # For Cuprite:
      page.driver.set_cookie("session_id", cookies[:session_id], {expires: Time.now + 3600, httpOnly: true, sameSite: :Lax})

      find("#button-sign-in-#{provider}").click
    end
  end
end
