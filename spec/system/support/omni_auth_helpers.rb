# Set OmniAuth test mode and failure condition
OmniAuth.config.test_mode = true
OmniAuth.config.on_failure = proc { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

module OmniAuthHelpers
  def login_with_google(user)
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
      provider: "google_oauth2",
      uid: user.id,  # Use the actual user ID instead of hardcoded "123456"
      info: {
        email: user.email,
        name: "#{user.firstname} #{user.lastname}"
      },
      credentials: {
        token: "mock_token",
        expires_at: Time.now + 1.week
      }
    })

    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google]
    # Directly visit the callback URL instead of going through the login flow
    visit "/admin/auth/google/callback"
  end

  def manual_login_with_google(user)
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
      provider: "google_oauth2",
      uid: user.id,
      info: {
        email: user.email,
        name: user.name
      },
      credentials: {
        token: "mock_token",
        expires_at: Time.now + 1.week
      }
    })

    visit admin_login_path
    expect(page).to have_css("#button-sign-in-google")
    find("#button-sign-in-google").click

    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google]
    visit "/admin"
  end

  def login_with_github(user)
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: "github",
      uid: "123456",
      info: {
        email: user.email,
        name: "#{user.firstname} #{user.lastname}"
      }
    })

    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
    # Directly visit the callback URL instead of going through the login flow
    visit "/admin/auth/github/callback"
  end

  def login_with_microsoft(user)
    OmniAuth.config.mock_auth[:microsoft] = OmniAuth::AuthHash.new({
      provider: "microsoft",
      uid: "123456",
      info: {
        email: user.email,
        first_name: user.firstname,
        last_name: user.lastname
      }
    })

    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:microsoft]
    # Directly visit the callback URL instead of going through the login flow
    visit "/admin/auth/microsoft/callback"
  end

  def login_as_admin(firstname: nil, lastname: nil, email: nil)
    user = admin_user
    login_with_google(user)

    # Add debugging
    if !page.has_content?("Dashboard")
      puts "Login failed. Current path: #{page.current_path}"
      puts "Page content: #{page.text}"
    end

    expect(page).to have_content("Dashboard")
  end

  def login_as_user(firstname: nil, lastname: nil, email: nil)
    login_with_google(regular_user)
  end

  # User defintions
  # TODO: Move to fixtures or Oaken?
  def admin_user
    Panda::CMS::User.find_or_create_by!(
      firstname: "Admin",
      lastname: "User",
      email: "admin@example.com",
      admin: true,
      image_url: "/panda-cms-assets/panda-nav.png"
    )
  end

  def regular_user
    Panda::CMS::User.find_or_create_by!(
      firstname: "Regular",
      lastname: "User",
      email: "regular@example.com",
      admin: false,
      image_url: "/panda-cms-assets/panda-nav.png"
    )
  end
end

RSpec.configure do |config|
  config.include OmniAuthHelpers, type: :system
end
