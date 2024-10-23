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
    # visits the "/admin" page, and sets the session cookie for the user.
    def login_as(user:, omniauth_mock_user:, provider: :github)
      # For Selenium:
      # cookies = ActionDispatch::TestRequest.create.cookie_jar
      # cookies.signed[:user_id] = {value: user.id, httpOnly: true, sameSite: :Lax}
      # page.driver.browser.manage.add_cookie(
      #   name: "user_id",
      #   value: cookies[:user_id],
      #   sameSite: :Lax,
      #   httpOnly: true
      # )

      # visit "/admin"

      # if page.driver.is_a?(Capybara::RackTest::Driver)
      #   browser = Capybara.current_session.driver.browser
      #   browser.manage.add_cookie(name: "user_id", value: user.id, sameSite: :Lax, httpOnly: true)
      # elsif page.driver.is_a?(Capybara::Cuprite::Driver)
      #   # if !page.driver.browser.cookies.set(
      #   #   name: "user_id",
      #   #   value: user.id,
      #   #   domain: Capybara.current_session.server.host,
      #   #   samesite: "lax",
      #   #   httponly: true,
      #   #   secure: false,
      #   #   expires: 1.year.from_now
      #   # )
      #   #   raise "Error setting cookie user_id; test aborting"
      #   # end
      #   page.driver.add_headers({
      #     "omniauth.auth" => omniauth_mock_user.to_json
      #   })
      # else
      #   raise "Unsupported driver: #{page.driver.class}"
      # end

      # PandaCms::Current.user = user

      # Rails.logger.error "User ID #{user.id} set as current user"

      # visit "/admin"
      # find("#button-sign-in-#{provider}").click
    end
  end
end
