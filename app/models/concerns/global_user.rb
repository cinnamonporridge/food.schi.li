module GlobalUser
  extend ActiveSupport::Concern

  GLOBAL_USER_EMAIL = "global@global.localhost".freeze

  included do
    def self.find_global_user
      find_by(email: GLOBAL_USER_EMAIL)
    end
  end

  def global_user?
    email == GLOBAL_USER_EMAIL
  end
end
