# Set OmniAuth test mode and failure condition
OmniAuth.config.test_mode = true
OmniAuth.config.on_failure = proc { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

module OmniAuthHelpers
  # Provider login helpers
  def login_with_google(user)
    auth_hash = OmniAuth::AuthHash.new({
      provider: "google",
      uid: "123456",
      info: {
        email: user.email,
        first_name: user.firstname,
        last_name: user.lastname
      }
    })

    OmniAuth.config.mock_auth[:google] = auth_hash
    Rails.application.env_config["omniauth.auth"] = auth_hash

    visit "/admin"
    find("#button-sign-in-google").click
  end

  def login_with_github(user)
    auth_hash = OmniAuth::AuthHash.new({
      provider: "github",
      uid: "123456",
      info: {
        email: user.email,
        name: "#{user.firstname} #{user.lastname}"
      }
    })

    OmniAuth.config.mock_auth[:github] = auth_hash
    Rails.application.env_config["omniauth.auth"] = auth_hash

    visit "/admin"
    find("#button-sign-in-github").click
  end

  def login_with_microsoft(user)
    auth_hash = OmniAuth::AuthHash.new({
      provider: "microsoft",
      uid: "123456",
      info: {
        email: user.email,
        first_name: user.firstname,
        last_name: user.lastname
      }
    })

    OmniAuth.config.mock_auth[:microsoft] = auth_hash
    Rails.application.env_config["omniauth.auth"] = auth_hash

    visit "/admin"
    find("#button-sign-in-microsoft").click
  end

  def login_as_admin(firstname: nil, lastname: nil, email: nil)
    login_with_google(admin_user)
  end

  def login_as_user(firstname: nil, lastname: nil, email: nil)
    login_with_google(regular_user)
  end

  # User defintions
  # TODO: Move to fixtures or Oaken?
  def admin_user
    PandaCms::User.find_or_create_by!(
      firstname: "Admin",
      lastname: "User",
      email: "admin@example.com",
      admin: true,
      image_url: "/panda-cms-assets/panda-nav.png"
    )
  end

  def regular_user
    PandaCms::User.find_or_create_by!(
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
