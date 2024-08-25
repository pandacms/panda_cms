module PandaCms
  module Features
    module SessionHelpers
      def sign_in_as(user)
        visit "/admin"
        click_button "Sign in with Google"
      end
    end
  end
end
